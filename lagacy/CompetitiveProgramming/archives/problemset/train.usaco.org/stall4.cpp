/*
ID: sujiao1
PROG: stall4
LANG: C++
*/
/*
PROGRAM: stall4
AUTHOR: Su Jiao
DATE: 2010-1-5
DESCRIPTION:
ũ��Լ���ϸ����ڸոս�����������ţ���ʹ�������µļ��̼��������ҵ��ǣ����ڹ���
���⣬ÿ��ţ������һ������һ�����ڣ�ũ��Լ����������ţ�ǽ���ţ������������ܿ�
����¶������ÿͷ��ţ��ֻԸ��������ϲ������Щţ���в��̡��ϸ����ڣ�ũ��Լ���ո���
��������ţ�ǵİ��õ���Ϣ��ÿͷ��ţϲ������Щţ�����̣���һ��ţ��ֻ������һͷ��
ţ����Ȼ��һͷ��ţֻ����һ��ţ���в��̡� 
������ţ�ǵİ��õ���Ϣ�����������䷽���� 
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
      static const int MAXM=402;
      static const int oo=1;
      int M;
      int c[MAXM+2][MAXM+2];
      int f[MAXM+2][MAXM+2];
      public:
      Application(char* input,char* output)
      :cin(input),cout(output)
      {
                              memset(c,0,sizeof(c));
                              int N,_M;
                              cin>>N>>_M;
                              for (int n=1;n<=N;n++)
                              {
                                  int end;
                                  cin>>end;
                                  for (int j=1;j<=end;j++)
                                  {
                                      int m;
                                      cin>>m;
                                      c[n][N+m]=1;
                                  }
                              }
                              for (int i=1;i<=N;i++) c[N+_M+1][i]=oo;
                              for (int j=N+1;j<=N+_M;j++) c[j][N+_M+2]=oo;
                              M=N+_M+2;
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      inline
      int min(int a,int b)
      {
          return a<b?a:b;
      }
      int maxFlow(int s,int t)
      {
          memset(f,0,sizeof(f));
          int p[MAXM+2];
          int value[MAXM+2];
          int U[MAXM+2];
          int U_open,U_close;
          for (;;)
          {
              memset(p,0,sizeof(p));
              memset(value,0,sizeof(value));
              p[s]=s;
              value[s]=oo;
              U_open=1;
              U_close=1;
              U[U_close]=s;
              while (!p[t])
              {
                    if (U_close>U_open) return calcFlow(s,t);
                    int v=U[U_close++];
                    for (int i=1;i<=M;i++)
                        if (c[v][i]&&(!p[i])&&(c[v][i]>f[v][i]))
                        {
                           U[++U_open]=i;
                           p[i]=v;
                           value[i]=min(value[v],c[v][i]-f[v][i]);
                        }
                    for (int i=1;i<=M;i++)
                        if (c[i][v]&&(!p[i])&&(f[i][v]>0))
                        {
                           U[++U_open]=i;
                           p[i]=v;
                           value[i]=min(value[v],f[i][v]);
                        }
              }
              int v=t;
              int dvalue=value[t];
              while (v!=s)
              {
                    int u=p[v];
                    if (c[u][v]>0)
                       f[u][v]+=dvalue;
                    else
                        f[u][v]-=dvalue;
                    v=u;
              }
          }
      }
      int calcFlow(int s,int t)
      {
          int v=0;
          for (int i=1;i<=M;i++)
              v+=f[s][i];
          return v;
      }
      int run()
      {
          cout<<maxFlow(M-1,M)<<endl;
          return 0;
      }
};

int main()
{
    Application app("stall4.in","stall4.out");
    return app.run();
}
