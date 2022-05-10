/*
PROGRAM: $PROGRAM
AUTHOR: Su Jiao
DATE: 2010-3-21
DESCRIPTION:
$DESCRIPTION
*/
#include <iostream>
using std::cin;
using std::cout;
#include <fstream>
using std::ifstream;
using std::ofstream;
#include <sstream>
using std::stringstream;
using std::endl;
#include <vector>
using std::vector;
#include <string>
using std::string;
#include <stack>
using std::stack;
#include <queue>
using std::queue;
#include <set>
using std::set;
#include <map>
using std::map;
using std::pair;
using std::make_pair;
#include <algorithm>
using std::sort;
#include <cassert>
//using std::assert;

class Application
{
      int N,M;
      vector<vector<char> > forward,backward; 
      public:
      Application() 
      {
                    cin>>N>>M;
                    forward.resize(N,vector<char>(M));
                    for (int i=0;i<N;i++)
                        for (int j=0;j<M;j++)
                            cin>>forward[i][j];
                    backward.resize(N,vector<char>(M));
                    for (int i=0;i<N;i++)
                        for (int j=0;j<M;j++)
                            cin>>backward[i][j];
      }
      int run()
      {
          vector<vector<int> > degree(N+1,vector<int>(M+1,0));
          vector<vector<bool> > link_up(N+1,vector<bool>(M+1,false)),
                              link_down(N+1,vector<bool>(M+1,false));
          for (int i=0;i<N;i++)
              for (int j=0;j<M;j++)
              {
                  switch (forward[i][j])
                  {
                         case 'X':
                              degree[i][j]++;
                              degree[i+1][j]++;
                              degree[i][j+1]++;
                              degree[i+1][j+1]++;
                              link_up[i][j]=true;
                              link_down[i][j]=true;
                              break;
                         case '/':
                              degree[i+1][j]++;
                              degree[i][j+1]++;
                              link_up[i][j]=true;
                              break;
                         case '\\':
                              degree[i][j]++;
                              degree[i+1][j+1]++;
                              link_down[i][j]=true;
                              break;
                         default:
                                 break;
                  }
                  switch (backward[i][j])
                  {
                         case 'X':
                              degree[i][j]--;
                              degree[i+1][j]--;
                              degree[i][j+1]--;
                              degree[i+1][j+1]--;
                              link_up[i][j]=true;
                              link_down[i][j]=true;
                              break;
                         case '/':
                              degree[i+1][j]--;
                              degree[i][j+1]--;
                              link_up[i][j]=true;
                              break;
                         case '\\':
                              degree[i][j]--;
                              degree[i+1][j+1]--;
                              link_down[i][j]=true;
                              break;
                         default:
                                 break;
                  }
              }
          for (int i=0;i<=N;i++)
              for (int j=0;j<=M;j++)
                  if (degree[i][j]<0) degree[i][j]=-degree[i][j];
          
          int answer=0;
          queue<pair<int,int> > q;
          vector<vector<bool> > inq(N+1,vector<bool>(M+1,false));
          for (int i=0;i<=N;i++)
              for (int j=0;j<=M;j++)
                  if (!inq[i][j])
                  {
                     int counter=0;
                     bool isABlock=false; 
                     
                     q.push(make_pair(i,j));
                     inq[i][j]=true;
                     counter+=degree[i][j];
                     while (!q.empty())
                     {
                           int gi=q.front().first,
                               gj=q.front().second;
                           #define inbox(i,j) ((i>=0)&&(i<=N)&&(j>=0)&&(j<=M))
                           #define push_if(i,j,if_what)\
                           if (inbox(i,j)&&(!inq[i][j])&&(if_what))\
                           {\
                              isABlock=true;\
                              q.push(make_pair(i,j));\
                              inq[i][j]=true;\
                              counter+=degree[i][j];\
                           }
                           push_if(gi+1,gj+1,link_down[gi][gj]); 
                           push_if(gi-1,gj-1,link_down[gi-1][gj-1]); 
                           push_if(gi-1,gj+1,link_up[gi-1][gj]); 
                           push_if(gi+1,gj-1,link_up[gi][gj-1]); 
                           #undef push_if
                           #undef inbox
                           q.pop();
                     }
                     if (counter) answer+=counter/2;
                     else if (isABlock) answer++;
                  }
          
          cout<<answer<<endl;
          return 0;
      }
};

int main()
{
    Application app;
    return app.run();
}
