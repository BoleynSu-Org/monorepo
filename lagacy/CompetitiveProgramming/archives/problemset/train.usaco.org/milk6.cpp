/*
ID: sujiao1
PROG: milk6
LANG: C++
*/
/*
PROGRAM: milk6
AUTHOR: Su Jiao
DATE: 2010-1-11
DESCRIPTION:
׷�黵ţ��
���һ����ֹ���ţ�̹�˾�ͷ�����һ����ù�����飺��˾��С�ķ�����һ����ţ�̡���
���ң��㷢������µ�ʱ�򣬻�ţ���Ѿ��������ͻ���������ͻ����ܴ󣬶��ҹ�ϵ���ӡ�
��֪������ţ��Ҫ�����ĸ������̣�����Ҫ������ţ���͵��������������;�����ͻ�����
һЩ�ֿ�����俨����ɣ�ÿ���������ڸ��Թ̶��������ֿ�֮�䵥������ţ�̡���׷����
Щ��ţ�̵�ʱ���б�Ҫ��֤�������͵�������������Ա���ʹĳЩ���俨��ֹͣ���䣬
����ֹͣÿ������������һ���ľ�����ʧ����������ǣ��ٱ�֤��ţ�̲��͵������̵�ǰ��
�£��ƶ���ֹͣ��������ķ�����ʹ��ʧ��С��
*/
#include <fstream>
using std::ifstream;
using std::ofstream;
using std::endl;
#include <cstring>
using std::memset;
#include <cstdlib>
using std::qsort;

class Application
{
      ifstream cin;
      ofstream cout;
      static const int MAXN=32;
      static const int MAXM=1000;
      static const int oo=~(1<<31);
      static const int OFFSET=10;
      struct Edge{int S,E,C,id;};
      int N,M;
      static Edge e[MAXM+2];
      int c[MAXN+2][MAXN+2];
      int f[MAXN+2][MAXN+2];
      bool deleteIt_bool[MAXM+2];
      int deleteIt[MAXM+2];
      int deleteIt_len;
      public:
      Application(char* input,char* output)
      :cin(input),cout(output)
      {
                              cin>>N>>M;
                              memset(c,0,sizeof(c));
                              memset(f,0,sizeof(f));
                              memset(deleteIt_bool,0,sizeof(deleteIt_bool));
                              memset(deleteIt,0,sizeof(deleteIt));
                              for (int i=1;i<=M;e[i].id=i++)
                                  cin>>e[i].S>>e[i].E>>e[i].C;
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      void initC(int deleteOne=0)
      {
           memset(c,0,sizeof(c));
           for (int i=1;i<=M;i++)
               if (i!=deleteOne&&!deleteIt_bool[i])
                  c[e[i].S][e[i].E]+=e[i].C;
      }
      inline
      int min(int a,int b)
      {
          return a<b?a:b;
      }
      int maxFlow(int s,int t)
      {
          memset(f,0,sizeof(f));
          int pre[MAXN+2];
          int value[MAXN+2];
          int q[MAXN+2];
          int open,close;
          for (;;)
          {
              memset(pre,0,sizeof(pre));
              memset(value,0,sizeof(value));
              pre[s]=s;
              value[s]=oo;
              open=1;
              close=1;
              q[open]=s;
              while ((close<=open)&&!pre[t])
              {
                    int u=q[close];
                    for (int v=1;v<=N;v++)
                        if (/*c[u][v]&&*/f[u][v]<c[u][v]&&!pre[v])
                        {
                           pre[v]=u;
                           value[v]=min(c[u][v]-f[u][v],value[u]);
                           q[++open]=v;
                        }
                    //for (int v=1;v<=N;v++)
                    //    if (/*c[v][u]&&*/c[v][u]>0&&!pre[v])
                    //    {
                    //       pre[v]=u;
                    //       value[v]=min(c[v][u],value[u]);
                    //       q[++open]=v;
                    //    }
                    close++;
              }
              if (!pre[t])
              {
                 int max=0;
                 for (int i=1;i<=N;i++)
                     max+=f[s][i];
                 return max;
              }
              for (int u=t;u!=pre[u];u=pre[u])
              {
                  if (c[pre[u]][u])
                     f[pre[u]][u]+=value[t];
                  else
                      f[u][pre[u]]-=value[t];
              }
          }
      }
      static
      int edge_compare(const void* _a,const void* _b)
      {
          const Edge* a=(const Edge*)(_a);
          const Edge* b=(const Edge*)(_b);
          if (a->C<b->C) return 1;
          if (a->C>b->C) return -1;
          return a->id-b->id;
      }
      static
      int deleteIt_compare(const void* _a,const void* _b)
      {
          const int a=*(const int*)(_a);
          const int b=*(const int*)(_b);
          if (e[a].id>e[b].id) return 1;
          if (e[a].id<e[b].id) return -1;
          return 0;
      }
      int run()
      {
          qsort(&e[1],M,sizeof(Edge),edge_compare);
          initC();
          int getMaxFlow=maxFlow(1,N);
          int nowMaxFlow=getMaxFlow;
          deleteIt_len=0;
          memset(deleteIt_bool,false,sizeof(deleteIt_bool));
          for (int i=1;i<=M;i++)
          {
              if (nowMaxFlow>=0)
              {
                 initC(i);
                 int newMaxFlow=maxFlow(1,N);
                 if (nowMaxFlow-newMaxFlow==e[i].C)
                 {
                    deleteIt[++deleteIt_len]=i;
                    nowMaxFlow=newMaxFlow;
                    deleteIt_bool[i]=true;
                 }
              }
              else break;
          }
          cout
          <<getMaxFlow<<" "
          <<deleteIt_len<<endl;
          qsort(&deleteIt[1],deleteIt_len,sizeof(int),deleteIt_compare);
          for (int i=1;i<=deleteIt_len;i++)
              cout<<e[deleteIt[i]].id<<endl;
          return 0;
      }
};
Application::Edge Application::e[MAXM+2];

int main()
{
    Application app("milk6.in","milk6.out");
    return app.run();
}
