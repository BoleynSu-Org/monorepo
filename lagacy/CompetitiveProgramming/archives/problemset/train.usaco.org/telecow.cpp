/*
ID: sujiao1
PROG: telecow
LANG: C++
*/
/*
PROGRAM: telecow
AUTHOR: Su Jiao
DATE: 2010-1-21
DESCRIPTION:
ũ��Լ������ţ��ϲ��ͨ�����ʱ�����ϵ���������ǽ�����һ����ţ�������磬�Ա㻥�ཻ
������Щ���������µķ�ʽ���͵��ʣ��������һ����c̨������ɵ�����a1,a2,...,a(c)��
��a1��a2������a2��a3�������ȵȣ���ô����a1��a(c)�Ϳ��Ի������ʡ� 
�ܲ��ң���ʱ����ţ�᲻С�Ĳȵ������ϣ�ũ��Լ���ĳ�Ҳ����������ԣ���̨��ù�ĵ���
�ͻỵ��������ζ����̨���Բ����ٷ��͵����ˣ���������̨������ص�����Ҳ�Ͳ�����
�ˡ� 
����ͷ��ţ���룺��������������ܻ������ʣ�������Ҫ��������̨�����أ����дһ����
��Ϊ���Ǽ��������Сֵ����֮��Ӧ�Ļ����ĵ��Լ��ϡ� 
����������Ϊ���� 
              1*
             /  
            3 - 2*
����ͼ��������2�����ӵ�3̨���ԡ�������Ҫ�ڵ���1��2֮�䴫����Ϣ������1��3��2��3ֱ
����ͨ���������3���ˣ�����1��2�㲻�ܻ�����Ϣ�ˡ� 
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
      static const int MAXN=100;
      static const int oo=~(1<<31);
      int N,M,s,t;
      int c[MAXN*2+2][MAXN*2+2];
      int f[MAXN*2+2][MAXN*2+2];
      public:
      Application(char* input,char* output)
                        :cin(input),cout(output)
      {
                        memset(c,0,sizeof(c));
                        cin>>N>>M>>s>>t;
                        for (int i=1;i<=N;i++)
                            c[i][next(i)]=c[next(i)][i]=1;
                        for (int i=1;i<=M;i++)
                        {
                            int v,u;
                            cin>>v>>u;
                            /* v-v'    v-v'
                               /\        /
                                 \     \/
                               u-u'    u-u' */
                            c[v][next(u)]=oo;
                            c[u][next(v)]=oo;
                        }
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      inline
      int next(int n)
      {
          return n+N;
      }
      inline
      int min(int a,int b)
      {
          return a<b?a:b;
      }
      
      int maxFlow(int s,int t,int l,int r)
      {
          //label(v)=(p[v],value[v])
          int p[MAXN*2+2];
          int value[MAXN*2+2];
          //U
          int U[MAXN*2+2];
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
                    if (U_close>U_open) return calcFlow(s,t,l,r);
                    
                    int v=U[U_close++];
                    for (int w=l;w<=r;w++)
                        if ((c[v][w]!=0)&&(p[w]==0))
                        {
                           if (f[v][w]<c[v][w])
                           {
                              p[w]=v;
                              value[w]=min(value[v],c[v][w]-f[v][w]);
                              U[++U_open]=w;
                           }
                        }
                    for (int w=l;w<=r;w++)
                        if ((c[w][v]!=0)&&(p[w]==0))
                        {
                           if (f[w][v]>0)
                           {
                              p[w]=v;
                              value[w]=min(value[v],f[w][v]);
                              U[++U_open]=w;
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
      int calcFlow(int s,int t,int l,int r)
      {
          int flow=0;
          for (int i=l;i<=r;i++)
              flow+=f[s][i];
          return flow;
      }
      int run()
      {
          int all=maxFlow(s,next(t),1,next(N));
          int rest=all;
          cout<<all<<endl;
          
          bool first=true;
          for (int i=1;(i<=N)&&rest;i++)
              if (i!=s&&i!=t)
              {
                 c[i][next(i)]=c[next(i)][i]=0;
                 int now=maxFlow(s,next(t),1,next(N));
                 if (now<rest)
                 {
                    rest=now;
                    if (first)
                    {
                       cout<<i;
                       first=false;
                    }
                    else cout<<" "<<i;
                 }
                 else c[i][next(i)]=c[next(i)][i]=oo;
              }
          cout<<endl;
          return 0;
      }
};

int main()
{
    Application app("telecow.in","telecow.out");
    return app.run();
}
