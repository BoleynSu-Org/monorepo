/*
ID: sujiao1
PROG: range
LANG: C++
*/
/*
PROGRAM: range
AUTHOR: Su Jiao
DATE: 2009-12-23
DESCRIPTION:
ũ��Լ����һƬ�߳���N (2 <= N <= 250)Ӣ��������������Ϸ���������ţ��(��ΪһЩ
ԭ��������ţֻ�������ε������ϳԲݡ�)�ź�����,������ţ�Ѿ��ٻ�һЩ���ء�( һЩ
1ƽ��Ӣ���������) 
ũ��Լ����Ҫͳ����Щ���Է�����ţ������������(������2x2��,����Щ�ϴ����������û
��һ�����Ǳ��ƻ��ģ�Ҳ����˵�����еĵ㶼�ǡ�1��)�� 
��Ĺ���Ҫ�ڱ���Ӧ������������ͳ�����в�ͬ�������η�������(>=2x2)�ĸ�������Ȼ��
��������������ص��� 
*/
#include <fstream>
using std::ifstream;
using std::ofstream;
using std::endl;
#include <cstring>
using std::memset;
#include <ctime>
using std::clock;

class Application
{
      ifstream cin;
      ofstream cout;
      static const int MAXN=250;//2 to 250
      static const int STATE=2;
      int N;
      bool map[MAXN+2][MAXN+2];
      bool f[STATE][MAXN+2][MAXN+2];
      int g[MAXN+2][MAXN+2];
      int h[MAXN+2][MAXN+2];
      int counter[MAXN+2];
      public:
      Application(char* input,char* output)
      :cin(input),cout(output)
      {
                              cin>>N;
                              cin.get();//ignore '\n'
                              char get;
                              for (int i=1;i<=N;i++)
                              {
                                  for (int j=1;j<=N;j++)
                                  {
                                      cin>>get;
                                      map[i][j]=(get=='1');
                                  }
                                  cin.get();//ignore '\n'
                              }
                              /*
                              for (int i=1;i<=N;i++)
                              {
                                  for (int j=1;j<=N;j++)
                                      cout<<map[i][j];
                                  cout<<endl;
                              }
                              */
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      inline
      int K(int k)
      {
          return k%2;
      }
      int run()
      {
          //init g and h
          memset(g,0,sizeof(g));
          for (int i=1;i<=N;i++)
              for (int j=1;j<=N;j++)
              {
                  if (map[i][j])
                  {
                     if (j==1) g[i][j]=1;
                     else
                     {
                         if (map[i][j-1]) g[i][j]=g[i][j-1]+1;
                         else g[i][j]=1;
                     }
                  }
                  else g[i][j]=0;
                  //cout<<i<<" "<<j<<" "<<g[i][j]<<endl;
              }
          
          memset(h,0,sizeof(h));
          for (int j=1;j<=N;j++)
              for (int i=1;i<=N;i++)
              {
                  if (map[i][j])
                  {
                     if (i==1) h[i][j]=1;
                     else
                     {
                         if (map[i-1][j]) h[i][j]=h[i-1][j]+1;
                         else h[i][j]=1;
                     }
                  }
                  else h[i][j]=0;
                  //cout<<i<<" "<<j<<" "<<h[i][j]<<endl;
              }
          
          memset(counter,0,sizeof(counter));
          for (int k=1;k<=N;k++)
          {
              if (k==1)
              {
                 for (int i=k;i<=N;i++)
                     for (int j=k;j<=N;j++)
                         f[K(k)][i][j]=map[i][j];
              }
              else
              {
                  for (int i=k;i<=N;i++)
                      for (int j=k;j<=N;j++)
                      {
                          if (f[K(k-1)][i-1][j-1])
                          {
                             f[K(k)][i][j]=true;
                             
                             if (g[i][j]<k) f[K(k)][i][j]=false;
                             if (h[i][j]<k) f[K(k)][i][j]=false;
                             /*
                             for (int c=i-k+1;c<=i;c++)
                                 if (!map[c][j]) f[K(k)][i][j]=false;
                             for (int c=j-k+1;c<=j;c++)
                                 if (!map[i][c]) f[K(k)][i][j]=false;
                             */
                             if (f[K(k)][i][j]) counter[k]++;
                          }
                          else
                              f[K(k)][i][j]=false;
                      }
              }
          }
          for (int i=2;i<=N;i++)
          {
              if (counter[i]>0) cout<<i<<" "<<counter[i]<<endl;
          }
          //cout<<clock()<<endl;
          return 0;
      }
};

int main()
{
    Application app("range.in","range.out");
    return app.run();
}
