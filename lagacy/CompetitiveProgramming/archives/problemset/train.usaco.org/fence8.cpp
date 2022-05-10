/*
ID: sujiao1
PROG: fence8
LANG: C++
*/
/*
PROGRAM: fence8
AUTHOR: Su Jiao
DATE: 2009-12-29
DESCRIPTION:
ũ��John׼����һ��դ����Χס�������������Ѿ�ȷ����դ������״����������ľ�Ϸ�����
Щ���⡣���ص��ӻ��������Ӹ�JohnһЩľ�壬��John�������Щľ�����ҳ������ܶ�����
��ľ�ϡ� 
��Ȼ��John������ľ�塣��ˣ�һ��9Ӣ�ߵ�ľ������г�һ��5Ӣ�ߺ�һ��4Ӣ�ߵ�ľ�� 
(��ȻҲ���г�3��3Ӣ�ߵģ��ȵ�)��John��һ���λ�֮�⣬���������ľ��ʱ��������ľ
�ϵ���ʧ�� 
����Ҫ��ľ�Ϲ���Ѿ��������㲻���г�����ľ�ϣ���û���á�
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
      static const int MAXR=1023;
      static const int MAXRI=128;
      static const int oo=1024*1024*1024;
      int N,R;
      int from[MAXN+2];
      int to[MAXR+2];
      int sum_from;
      int sum_to[MAXR+2];
      int waste;
      int waste_most;
      int answer;
      public:
      Application(char* input,char* output)
      :cin(input),cout(output)
      {
                              cin>>N;
                              for (int i=1;i<=N;i++)
                                  cin>>from[i];
                              cin>>R;
                              for (int i=1;i<=R;i++)
                                  cin>>to[i];
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      void qsort_larger(int* l,int* r)
      {
           int* i=l;
           int* j=r;
           int mid=*(l+(r-l)/2);
           while (i<=j)
           {
                 while (*i>mid) i++;
                 while (*j<mid) j--;
                 if (i<=j)
                 {
                    int swap=*i;
                    *i=*j;
                    *j=swap;
                    i++;
                    j--;
                 }
           }
           if (l<j) qsort_larger(l,j);
           if (i<r) qsort_larger(i,r);
      }
      void qsort_smaller(int* l,int* r)
      {
           int* i=l;
           int* j=r;
           int mid=*(l+(r-l)/2);
           while (i<=j)
           {
                 while (*i<mid) i++;
                 while (*j>mid) j--;
                 if (i<=j)
                 {
                    int swap=*i;
                    *i=*j;
                    *j=swap;
                    i++;
                    j--;
                 }
           }
           if (l<j) qsort_smaller(l,j);
           if (i<r) qsort_smaller(i,r);
      }
      bool search(int r,int n)
      {
           //cout<<r<<"search!"<<endl;
           if (r==0)
              return true;
           
           if (waste>waste_most)
              return false;
           
           int start=1;
           if (to[r]==to[r+1]) start=n;
           
           bool can=false;
           for (int i=start;i<=N;i++)
           {
               if (from[i]>=to[r])
               {
                  from[i]-=to[r];
                  if (from[i]<to[1]) waste+=from[i];
                  can=search(r-1,i);
                  if (from[i]<to[1]) waste-=from[i];
                  from[i]+=to[r];
               }
               if (can) break;
           }
           return can;
      }
      int run() 
      {
          qsort_larger(&from[1],&from[N]);
          qsort_smaller(&to[1],&to[R]);
          
          sum_from=0;
          for (int i=1;i<=N;i++)
              sum_from+=from[i];
          sum_to[0]=0;
          for (int i=1;i<=R;i++)
              sum_to[i]=sum_to[i-1]+to[i];
          
          while (to[R]>from[1]) R--;
          while (sum_to[R]>sum_from) R--;
          /*
          for (int i=1;i<=N;i++)
              cout<<from[i]<<" ";
          cout<<endl;
          for (int i=1;i<=R;i++)
              cout<<to[i]<<" ";
          cout<<endl;
          */
          int l=0,r=R;
          while ((l<R)&&(l<N)&&(from[l+1]>to[l+1])) l++;
          
          for (;l<=r;)
          {
              answer=(l+r+1)/2;
              //cout<<l<<" "<<r<<" "<<answer<<endl;
              
              waste=0;
              waste_most=sum_from-sum_to[answer];
              
              bool can=search(answer,1);
              //cout<<"can:"<<can<<endl;
              if (can)
                 l=answer+1;
              else
                  r=answer-1;
          }
          cout<<answer<<endl;
          return 0;
      }
};

int main()
{
    Application app("fence8.in","fence8.out");
    return app.run();
}
