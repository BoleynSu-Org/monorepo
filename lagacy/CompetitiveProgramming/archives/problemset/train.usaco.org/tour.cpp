/*
ID: sujiao1
PROG: tour
LANG: C++
*/
/*
PROGRAM: tour
AUTHOR: Su Jiao
DATE: 2010-1-18
DESCRIPTION:
��Ӯ����һ�����չ�˾�ٰ�ı�������Ʒ��һ�ż��ô��λ�Ʊ����������Һ��չ�˾����
�������ߵĳ��п�ʼ��Ȼ��һֱ���������У�ֱ���㵽����ߵĳ��У����ɶ�������
�أ�ֱ����ص���ʼ�ĳ��С��������п�ʼ�ĳ���֮�⣬ÿ������ֻ�ܷ���һ�Σ���Ϊ��ʼ
�ĳ��бض�Ҫ���������Σ������еĿ�ʼ�ͽ������� 
��Ȼ������ʹ��������˾�ĺ��߻����������Ľ�ͨ���ߡ� 
����������չ�˾���ŵĳ��е��б�����������֮���ֱ�ﺽ���б��ҳ��ܹ����ʾ���
�ܶ�ĳ��е�·�ߣ�����·�߱�����������������Ҳ���Ǵ��б��еĵ�һ�����п�ʼ���У�
���ʵ��б������һ������֮���ٷ��ص�һ�����С� 
*/
#include <fstream>
using std::ifstream;
using std::ofstream;
using std::endl;
#include <cstring>
using std::memset;
#include <string>
using std::string;

class Application
{
      ifstream cin;
      ofstream cout;
      static const int MAXN=100;
      static const int oo=MAXN;
      int N,V;
      string city[MAXN+2];
      bool map[MAXN+2][MAXN+2];
      int f[MAXN+2][MAXN+2];
      int answer;
      public:
      Application(char* input,char* output)
                        :cin(input),cout(output)
      {
                        memset(map,false,sizeof(map));
                        cin>>N>>V;
                        for (int i=1;i<=N;i++)
                            cin>>city[i];
                        for (int i=1;i<=V;i++)
                        {
                            string a,b;
                            int ida,idb;
                            cin>>a>>b;
                            for (int i=1;i<=N;i++)
                            {
                                if (city[i]==a) ida=i;
                                if (city[i]==b) idb=i;
                            }
                            map[ida][idb]=map[idb][ida]=true;
                        }
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      inline
      int max(int a,int b)
      {
          return a>b?a:b;
      }
      int run()
      {
          f[1][1]=1;
          for (int i=1;i<=N;i++)
              for (int j=i+1;j<=N;j++)
              {
                  f[i][j]=-oo;
                  for (int k=1;k<j;k++)
                      if (map[k][j]&&f[i][k]>0)
                         f[i][j]=max(f[i][j],f[i][k]+1);
                  f[j][i]=f[i][j];
                  //cout<<"f["<<i<<","<<j<<"]="<<f[i][j]<<endl;
              }
          answer=-oo;
          for (int i=1;i<N;i++)
              if (map[i][N])
                 answer=max(answer,f[i][N]);
          if (answer<2) answer=1;
          cout<<answer<<endl;
          return 0;
      }
};

int main()
{
    Application app("tour.in","tour.out");
    return app.run();
}
