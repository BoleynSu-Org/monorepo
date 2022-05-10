/*
ID: sujiao1
PROG: nuggets
LANG: C++
*/
/*
PROGRAM: nuggets
AUTHOR: Su Jiao
DATE: 2009-12-29
DESCRIPTION:
ũ���ʵ���ţ�����ڽ��ж�������Ϊ������˵�������ڿ�������һ���²�Ʒ������ţ
�顣��ţ�������뾡һ�а취�����ֿ��µ�������������ţ�ǽ��ж����Ĳ���֮һ�ǡ���
�ʵİ�װ����������������ţ��˵���������ֻ��һ����װ3�顢6�����10������ְ�װ
�а�װ����ţ�飬��Ͳ���������һ��ֻ����1��2��4��5��7��8��11��14����17������ţ
��Ĺ˿��ˡ����ʵİ�װ��ζ�����ʵĲ�Ʒ���� 
��������ǰ�����Щ��ţ��������װ�е�������N(1<=N<=10)��N������ͬ�����װ����
������ţ�������������(1<=i<=256)������˿Ͳ�����������װ��(ÿ�ֺ�����������)��
������ţ�����������������й��򷽰����ܵõ�������߲����ڲ����򵽿��������ޣ�
�����0�������򵽵����������������ڣ�������2,000,000,000�� 
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
      static const int MAX=2000000000;
      static const int MAXN=10;
      static const int MAXA=256;
      int N;
      int a[MAXN+2];
      bool f[MAXA*MAXA+2];
      public:
      Application(char* input,char* output)
      :cin(input),cout(output)
      {
                              cin>>N;
                              for (int i=1;i<=N;i++)
                                  cin>>a[i];
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
      void sort()
      {
           for (int i=1;i<=N;i++)
               for (int j=i+1;j<=N;j++)
                   if (a[i]>a[j])
                   {
                      int swap=a[i];
                      a[i]=a[j];
                      a[j]=swap;
                   }
      }
      int gcd_all()
      {
          int ret=0;
          for (int i=1;i<=N;i++)
              ret=gcd(a[i],ret);
          return ret;
      }
      int getAnswer()
      {
          memset(f,false,sizeof(f));
          int MAX=a[N]*a[N-1];
          f[0]=true;
          for (int i=0;i<=MAX;i++)
              for (int j=1;j<=N;j++)
                  f[i+a[j]]|=f[i];
          for (;MAX>=1;MAX--)
              if (!f[MAX]) break;
          return MAX;
      }
      int run()
      {
          sort();
          if (gcd_all()!=1)
             cout<<0<<endl;
          else
              cout<<getAnswer()<<endl;
          return 0;
      }
};

int main()
{
    Application app("nuggets.in","nuggets.out");
    return app.run();
}
