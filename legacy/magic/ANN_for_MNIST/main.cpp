// http://neuralnetworksanddeeplearning.com/chap1.html

#include <armadillo>
#include <cmath>
#include <iostream>
#include <random>
#include <vector>

using namespace std;
using namespace arma;

class network {
  vector<vec> biases;
  vector<mat> weights;

  static mt19937 rand;
  static double sigmoid(double x) {
    return 1. / (1. + exp(-x));
  }
  static double sigmoid_prime(double x) {
    return sigmoid(x) * (1. - sigmoid(x));
  }
  static vec cost_derivative(vec output_activations,
                             vec y) {  // C(a) = 1/2 * (a - y)^2
    return output_activations - y;
  }

  void update_mini_batch(
      const vector<pair<vec, vec>>::iterator mini_batch_begin,
      const vector<pair<vec, vec>>::iterator mini_batch_end, double eta) {
    int mini_batch_size = mini_batch_end - mini_batch_begin;
    vector<vec> nabla_b(biases.size());
    for (int i = 0; i < nabla_b.size(); i++) {
      nabla_b[i].zeros(arma::size(biases[i]));
    }
    vector<mat> nabla_w(weights.size());
    for (int i = 0; i < nabla_b.size(); i++) {
      nabla_w[i].zeros(arma::size(weights[i]));
    }
    for (auto it = mini_batch_begin; it != mini_batch_end; ++it) {
      const auto& [x, y] = *it;
      auto [delta_nabla_b, delta_nabla_w] = backprop(x, y);
      for (int i = 0; i < nabla_b.size(); i++) {
        nabla_b[i] += delta_nabla_b[i];
      }
      for (int i = 0; i < nabla_w.size(); i++) {
        nabla_w[i] += delta_nabla_w[i];
      }
    }
    for (int i = 0; i < biases.size(); i++) {
      biases[i] -= (eta / mini_batch_size) * nabla_b[i];
    }
    for (int i = 0; i < weights.size(); i++) {
      weights[i] -= (eta / mini_batch_size) * nabla_w[i];
    }
  }
  pair<vector<vec>, vector<mat>> backprop(vec x, vec y) {
    vector<vec> nabla_b(biases.size());
    for (int i = 0; i < nabla_b.size(); i++) {
      nabla_b[i].zeros(arma::size(biases[i]));
    }
    vector<mat> nabla_w(weights.size());
    for (int i = 0; i < nabla_w.size(); i++) {
      nabla_w[i].zeros(arma::size(weights[i]));
    }
    vec activation = x;
    vector<vec> activations = {x};
    vector<vec> zs = {};
    for (int i = 0; i < biases.size(); i++) {
      activation = weights[i] * activation + biases[i];
      zs.push_back(activation);
      activation.transform(sigmoid);
      activations.push_back(activation);
    }
    vec delta = cost_derivative(activations.back(), y) %
                zs.back().transform(sigmoid_prime);
    nabla_b.back() = delta;
    nabla_w.back() = delta * activations[activations.size() - 2].t();
    for (int i = 2; i <= biases.size(); i++) {
      vec sp = zs[biases.size() - i];
      sp.transform(sigmoid_prime);
      delta = weights[weights.size() - i + 1].t() * delta % sp;
      nabla_b[nabla_b.size() - i] = delta;
      nabla_w[nabla_w.size() - i] =
          delta * activations[activations.size() - i - 1].t();
    }
    return make_pair(nabla_b, nabla_w);
  }
  int evaluate(const vector<pair<vec, int>>& test_data) {
    int correct = 0;
    for (const auto& [x, y] : test_data) {
      if (feedforward(x).index_max() == y) {
        correct++;
      }
    }
    return correct;
  }

 public:
  network(const vector<int>& sizes)
      : biases(sizes.size() - 1), weights(sizes.size() - 1) {
    for (int i = 0; i < sizes.size() - 1; i++) {
      biases[i].randn(sizes[i + 1]);
      weights[i].randn(sizes[i + 1], sizes[i]);
    }
  }
  vec feedforward(vec a) {
    for (int i = 0; i < biases.size(); i++) {
      a = weights[i] * a + biases[i];
      a.transform(sigmoid);
    }
    return a;
  }
  void SGD(vector<pair<vec, vec>> training_data, int epochs,
           int mini_batch_size, double eta,
           const vector<pair<vec, int>>& test_data) {
    int n = training_data.size();
    for (int epoch = 1; epoch <= epochs; epoch++) {
      shuffle(training_data.begin(), training_data.end(), rand);
      for (int i = 0; i + mini_batch_size <= n; i += mini_batch_size) {
        update_mini_batch(training_data.begin() + i,
                          training_data.begin() + min(i + mini_batch_size, n),
                          eta);
      }
      cout << "Epoch " << epoch << "/" << epochs;
      if (test_data.size()) {
        cout << " : " << evaluate(test_data) << "/" << test_data.size();
      }
      cout << endl;
    }
  }
};
mt19937 network::rand;

int main() {
  vector<pair<vec, vec>> training_data;
  {
    ifstream cin("training_data.txt");
    double x0;
    while (cin >> x0) {
      vec x(784);
      x[0] = x0;
      for (int i = 1; i < x.size(); i++) cin >> x[i];
      vec y(10);
      for (int i = 0; i < 10; i++) cin >> y[i];
      training_data.emplace_back(x, y);
    }
  }
  vector<pair<vec, int>> test_data;
  {
    ifstream cin("test_data.txt");
    double x0;
    while (cin >> x0) {
      vec x(784);
      x[0] = x0;
      for (int i = 1; i < x.size(); i++) cin >> x[i];
      int y;
      cin >> y;
      test_data.emplace_back(x, y);
    }
  }
  network net({784, 30, 10});
  net.SGD(training_data, 30, 10, 3.0, test_data);
}
