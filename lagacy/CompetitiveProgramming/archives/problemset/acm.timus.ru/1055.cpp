/*
PROGRAM: $PROGRAM
AUTHOR: Su Jiao
DATE: $DATE
DESCRIPTION:
$DESCRIPTION
*/
#include <iostream>
using std::cin;
using std::cout;
#include <fstream>
using std::ifstream;
using std::ofstream;
#include <sstream>
using std::stringstream;
using std::endl;
#include <vector>
using std::vector;
#include <string>
using std::string;
#include <stack>
using std::stack;
#include <queue>
using std::queue;
#include <set>
using std::set;
#include <map>
using std::map;
using std::pair;
using std::make_pair;
#include <algorithm>
using std::sort;
#include <cassert>
//using std::assert;

class Application
{
      static const int oo=50000;
      int N,M;
      int answer;
      vector<int> prime;
      vector<int> counter;
      void get_prime()
      {
           prime.push_back(2);
           for (int i=3;i<=oo;i++)
           {
               bool can=true;
               for (int j=0;j<prime.size();j++)
                   if (i%prime[j]==0)
                   {
                      can=false;
                      break;
                   }
               if (can) prime.push_back(i);
           }
      }
      void calc(int n,int delta)
      {
          for (int i=0;i<prime.size();i++)
          {
              int x=n;
              while (x) counter[i]+=delta*(x/=prime[i]);
          }
      }
      void get_counter(int n,int m)
      {
           counter.resize(prime.size(),0);
           calc(n,1);
           calc(m,-1);
           calc(n-m,-1);
      }
      public:
      Application()
      {
                   cin>>N>>M;
      }
      int run()
      {
          get_prime();
          get_counter(N,M);
          answer=0;
          for (int i=0;i<counter.size();i++)
              if (counter[i]) answer++;
          cout<<answer<<endl;
          return 0;
      }
};

int main()
{
    Application app;
    return app.run();
}
