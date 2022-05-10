/*
ID: sujiao1
PROG: fence6
LANG: C++
*/
/*
PROGRAM: fence6
AUTHOR: Su Jiao
DATE: 2010-1-2
DESCRIPTION:
ũ���ʵ������ϵ�����Ѿ�ʧȥ�����ˡ����Ƿֳ���1~200Ӣ�߳����߶Ρ�ֻ�����߶ε�
�˵㴦�������������߶Σ���ʱ������һ���˵��ϻ����������ϵ���ʡ��������γ���һ
�����ָ��˲��ʵ������������뽫�����ָ�ԭ��������������ǣ������ȵ�֪����������һ
��������ܳ���С�����ʽ�����ÿ����ʴ�1��N�����˱�ţ�N=�߶ε�����������֪��ÿ��
��ʵ����������ԣ� 
�ö���ʵĳ��� 
�ö���ʵ�һ�������ӵ���һ����ʵı�� 
�ö���ʵ���һ�������ӵ���һ����ʵı�� 
���˵��ǣ�û�������������������һ���й������ηָ����������ݣ�дһ����������
������зָ������������С���ܳ��� 
���磬���1~10���������ͼ����ʽ��ɣ��������������ʵı�ţ��� 
          1
  +---------------+
  |\             /|
 2| \7          / |
  |  \         /  |
  +---+       /   |6
  | 8  \     /10  |
 3|     \9  /     |
  |      \ /      |
  +-------+-------+
      4       5
��ͼ���ܳ���С����������2��7��8������γɵġ� 
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
      static const int MAXNEXT=8;
      static const int oo=512*1024*1024;
      int N;
      int map[MAXN+2][MAXN+2];
      int dist[MAXN+2][MAXN+2];
      bool cross[MAXN+2][MAXN+2][MAXN+2];
      int answer;
      public:
      Application(char* input,char* output)
      :cin(input),cout(output)
      {
                              cin>>N;
                              
                              for (int i=1;i<=N;i++)
                                  for (int j=1;j<=N;j++)
                                      map[i][j]=(i==j)?0:oo;
                              
                              memset(cross,false,sizeof(cross));
                              for (int i=1;i<=N;i++)
                              {
                                  int id,length,s1,s2;
                                  cin>>id>>length>>s1>>s2;
                                  int next;
                                  int n1[MAXNEXT+2];
                                  int n2[MAXNEXT+2];
                                  for (int j=1;j<=s1;j++)
                                  {
                                      cin>>next;
                                      n1[j]=next;
                                      if (map[id][next]==oo)
                                         map[id][next]=length;
                                      else
                                          map[id][next]+=length;
                                      if (map[next][id]==oo)
                                         map[next][id]=length;
                                      else
                                          map[next][id]+=length;
                                  }
                                  for (int j=1;j<=s1;j++)
                                      for (int k=1;k<=s1;k++)
                                          cross[id][n1[j]][n1[k]]=true;
                                  for (int j=1;j<=s2;j++)
                                  {
                                      cin>>next;
                                      n2[j]=next;
                                      if (map[id][next]==oo)
                                         map[id][next]=length;
                                      else
                                          map[id][next]+=length;
                                      if (map[next][id]==oo)
                                         map[next][id]=length;
                                      else
                                          map[next][id]+=length;
                                  }
                                  for (int j=1;j<=s2;j++)
                                      for (int k=1;k<=s2;k++)
                                          cross[id][n2[j]][n2[k]]=true;
                              }
                              //for (int i=1;i<=N;i++)
                              //{
                              //    for (int j=1;j<=N;j++)
                              //        cout<<map[i][j]<<" ";
                              //    cout<<endl;
                              //}
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      int min(int a,int b)
      {
          return a<b?a:b;
      }
      int run()
      {
          for (int i=1;i<=N;i++)
              for (int j=1;j<=N;j++)
                  //cout<<"f["<<i<<","<<j<<"]="<<(
                  dist[i][j]=map[i][j];
                  //)<<endl;
          
          answer=oo;
          for (int k=1;k<=N;k++)
          {
              for (int i=1;i<k;i++)
                  for (int j=i+1;j<k;j++)
                  if (!cross[i][j][k])
                  {
                      //cout<<i<<" "<<j<<" "<<k<<" "<<map[i][k]+map[k][j]+dist[j][i]<<endl;
                      answer=min(answer,map[i][k]+map[k][j]+dist[j][i]);
                  }
              for (int i=1;i<=N;i++)
                  for (int j=1;j<=N;j++)
                      dist[i][j]=min(dist[i][j],dist[i][k]+dist[k][j]);
          }
          answer=answer/2;
          cout<<answer<<endl;
          return 0;
      }
};

int main()
{
    Application app("fence6.in","fence6.out");
    return app.run();
}
