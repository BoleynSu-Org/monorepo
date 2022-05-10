/*
ID: sujiao1
PROG: ditch
LANG: C++
*/
/*
PROGRAM: ditch
AUTHOR: Su Jiao
DATE: 2010-1-4
DESCRIPTION:
��ũ��Լ����ũ���ϣ�ÿ�����꣬Bessie��ϲ������Ҷ�ݵؾͻ�����һ̶ˮ������ζ�Ų�
�ر�ˮ��û�ˣ�����С��Ҫ����������Ҫ���൱��һ��ʱ�䡣��ˣ�ũ��Լ���޽���һ��
��ˮϵͳ��ʹ����Ĳݵ��������ˮ��û�ķ��գ����õ��ģ���ˮ�����򸽽���һ��С
Ϫ������Ϊһ��һ���ļ�ʦ��ũ��Լ���Ѿ���ÿ����ˮ����һ�˰����˿���������������
�Կ���������ˮ����ˮ������ 
ũ��Լ��֪��ÿһ����ˮ��ÿ���ӿ���������ˮ��������ˮϵͳ��׼ȷ���֣����Ϊˮ̶
���յ�ΪСϪ��һ����������Ҫע����ǣ���Щʱ���һ������һ����ֻ��һ����ˮ���� 
������Щ��Ϣ�������ˮ̶��ˮ��СϪ��������������ڸ�����ÿ����ˮ������ˮֻ����
��һ������������ע����ܻ������ˮ�������������Ρ�
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
      static const int MAXM=200;
      static const int oo=1024*1024*1024;
      int M;
      //C((v,u))=c[v][u]
      int c[MAXM+2][MAXM+2];
      //F((v,u))=f[v][u]
      int f[MAXM+2][MAXM+2];
      public:
      Application(char* input,char* output)
      :cin(input),cout(output)
      {
                              int N;
                              cin>>N>>M;
                              memset(c,0,sizeof(c));
                              for (int i=1;i<=N;i++)
                              {
                                  int v,u;
                                  cin>>v>>u;
                                  int C;
                                  cin>>C;
                                  c[v][u]+=C;
                              }
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      inline 
      int h(int n)
      {
          return n%MAXM;
      }
      inline
      int min(int a,int b)
      {
          return a<b?a:b;
      }
      int maxFlow(int s,int t)
      {
          //label(v)=(p[v],value[v])
          int p[MAXM+2];
          int value[MAXM+2];
          //U
          int U[MAXM+2];
          int U_close,U_open;
          //init flow
          memset(f,0,sizeof(f));
          
          for (;;)//find max flow
          {
              //for each v
              //label(v)=(null,0)
              memset(p,0,sizeof(p));
              memset(value,0,sizeof(value));
              //label(s)=(s,oo)
              p[s]=s;
              value[s]=oo;
              
              //U={s}
              U_close=1;
              U_open=1;
              U[U_close]=s;
              
              while (p[t]==0)//t is not labeled
              {
                    if (U_close>U_open) return calcFlow(s,t);
                    
                    int v=U[h(U_close++)];
                    for (int w=1;w<=M;w++)
                        if ((c[v][w]!=0)&&(p[w]==0))
                        {
                           if (f[v][w]<c[v][w])
                           {
                              p[w]=v;
                              value[w]=min(value[v],c[v][w]-f[v][w]);
                              U[h(++U_open)]=w;
                           }
                        }
                    for (int w=1;w<=M;w++)
                        if ((c[w][v]!=0)&&(p[w]==0))
                        {
                           if (f[w][v]>0)
                           {
                              p[w]=v;
                              value[w]=min(value[v],f[w][v]);
                              U[h(++U_open)]=w;
                           }
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
          int flow=0;
          for (int i=1;i<=M;i++)
              flow+=f[s][i];
          return flow;
      }
      int run()
      {
          cout<<maxFlow(1,M)<<endl;
          return 0;
      }
};

int main()
{
    Application app("ditch.in","ditch.out");
    return app.run();
}
