/*
ID: sujiao1
PROG: fence9
LANG: C++
*/
/*
PROGRAM: fence9
AUTHOR: Su Jiao
DATE: 2009-12-28
DESCRIPTION:
�ڱ����У������ָ���������Ϊ�����ĵ㡣 
Ϊ��Ȧ������ţ��ũ��Լ��������һ�������εĵ���������ԭ�㣨0,0��ǣ��һ��ͨ��ĵ�
�ߣ����Ӹ��[n,m]��0<=n<32000,0<m<32000���������Ӹ��[p,0]��p>0�������ص�ԭ�㡣 
ţ�����ڲ���������������±��ŵ������ڲ���ÿһ������ϣ�ʮ��������ţ�������һ��
��������˵�����ţ���Բ����Ա��ŵ��ø��֮�ϡ���ô�ж���ͷţ���Ա��ŵ�ũ��Լ����
������ȥ�أ� 
*/
#include <fstream>
using std::ifstream;
using std::ofstream;
using std::endl;
#include <cstring>
using std::memset;

class Application
{
      ifstream cin;
      ofstream cout;
      int n,m,p;
      int answer;
      public:
      Application(char* input,char* output)
      :cin(input),cout(output)
      {
                              cin>>n>>m>>p;
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      int gcd(int a,int b)
      {
          return b?gcd(b,a%b):a;
      }
      int abs(int n)
      {
          return n>0?n:-n;
      }
      int online()
      {
          return gcd(n,m)+gcd(abs(p-n),m)+p;
      }
      int run()
      {
          answer=(m*p/2+1-online()/2);
          cout<<answer<<endl;
          return 0;
      }
};

int main()
{
    Application app("fence9.in","fence9.out");
    return app.run();
}
