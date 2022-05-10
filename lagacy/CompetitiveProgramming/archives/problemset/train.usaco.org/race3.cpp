/*
ID: sujiao1
PROG: race3
LANG: C++
*/
/*
PROGRAM: race3
AUTHOR: Su Jiao
DATE: 2010-1-9
DESCRIPTION:
ͼһ��ʾһ�νֵ����ܵ��ܵ������Կ�����һЩ·�ڣ��� 0 �� N ��������ţ�����������Щ·�ڵļ�ͷ��·�� 0 ���ܵ�����㣬·�� N ���ܵ����յ㡣��ͷ��ʾ���е����˶�Ա�ǿ���˳�Žֵ���һ��·���ƶ�����һ��·�ڣ�ֻ�ܰ��ռ�ͷ��ָ�ķ��򣩡����˶�Ա����·��λ��ʱ��������ѡ������һ�������·�������Ľֵ��� 
ͼһ���� 10 ��·�ڵĽֵ� һ�����õ��ܵ��������¼����ص㣺 
ÿһ��·�ڶ���������㵽� 
������һ��·�ڶ����Ե����յ㡣 
�յ㲻ͨ���κ�·�ڡ� 
�˶�Ա���ؾ������е�·������ɱ�������Щ·��ȴ��ѡ������һ��·�߶����뵽��ģ���Ϊ�����ɱ��⡱�ģ���������������У���Щ·���� 0��3��6��9�����ڸ��������õ��ܵ�����ĳ���Ҫȷ�������ɱ��⡱��·�ڵļ��ϣ������������յ㡣 
�������Ҫ��������С�Ϊ�˴ﵽ���Ŀ�ģ�ԭ�����ܵ������Ϊ�����ܵ���ÿ��ʹ��һ���ܵ�����һ�죬���Ϊ·�� 0���յ�Ϊһ�����м�·�ڡ����ڶ��죬������Ǹ��м�·�ڣ����յ�Ϊ·�� N�����ڸ��������õ��ܵ�����ĳ���Ҫȷ�����м�·�ڡ��ļ��ϡ�������õ��ܵ� C ���Ա�·�� S �ֳ������֣��������ֶ������õģ����� S ��ͬ�����Ҳ��ͬ���յ㣬ͬʱ���ָ��������������������������1������֮��û�й�ͬ�Ľֵ���2��S Ϊ����Ψһ�Ĺ����㣬���� S ��Ϊ����һ�����յ������һ������㡣��ô���ǳ� S Ϊ���м�·�� ������������ֻ��·�� 3 ���м�·�ڡ� 
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
      static const int MAXN=50;
      bool map[MAXN+2][MAXN+2];
      int N;
      bool got1[MAXN+2];
      bool got2[MAXN+2];
      int answer1[MAXN+2];
      int answer1_len;
      int answer2[MAXN+2];
      int answer2_len;
      public:
      Application(char* input,char* output)
      :cin(input),cout(output)
      {
                              memset(map,false,sizeof(map));
                              int id=0;
                              int get;
                              for (;;)
                              {
                                  cin>>get;
                                  if (get==-1)
                                  {
                                     id--;
                                     break;
                                  }
                                  else if (get==-2) id++;
                                  else
                                  {
                                      map[id][get]=true;
                                  }
                              }
                              N=id;
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      void dfs1(int from,int cannot)
      {
           if (from==cannot) return;
           got1[from]=true;
           for (int i=0;i<=N;i++)
               if (map[from][i]&&!got1[i])
                  dfs1(i,cannot);
      }
      void dfs2(int from)
      {
           got2[from]=true;
           for (int i=0;i<=N;i++)
               if (map[from][i]&&!got2[i])
                  dfs2(i);
      }
      int run()
      {
          answer1_len=0;
          answer2_len=0;
          for (int i=1;i<N;i++)
          {
              memset(got1,false,sizeof(got1));
              dfs1(0,i);
              if (!got1[N])
              {
                 answer1[++answer1_len]=i;
                 memset(got2,false,sizeof(got2));
                 dfs2(i);
                 bool isAnswer=true;
                 for (int j=0;j<=N;j++)
                     if (got1[j]&&got2[j])
                        isAnswer=false;
                 if (isAnswer)
                    answer2[++answer2_len]=i;
              }
          }
          cout<<answer1_len;
          for (int i=1;i<=answer1_len;i++)
              cout<<" "<<answer1[i];
          cout<<endl;
          cout<<answer2_len;
          for (int i=1;i<=answer2_len;i++)
              cout<<" "<<answer2[i];
          cout<<endl;
          return 0;
      }
};

int main()
{
    Application app("race3.in","race3.out");
    return app.run();
}
