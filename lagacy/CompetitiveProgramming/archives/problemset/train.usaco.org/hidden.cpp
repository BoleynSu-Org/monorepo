/*
ID: sujiao1
PROG: hidden
LANG: C++
*/
/*
PROGRAM: hidden
AUTHOR: Su Jiao
DATE: 2010-1-22
DESCRIPTION:
��ʱ�����Ա�к���ֵķ������������ǵĿ��Billy"Hacker"Geits��ѡ��һ���ַ���S
����L��Сд��ĸ��ɣ�5<=L<=100,000����Ȼ������S˳ʱ���Ƴ�һ��Ȧ��ÿ��ȡһ������
ͷ��ĸ��˳ʱ������ȡ��ĸ�����һ���ַ������������õ�һЩ�ַ������������������ȡ
����һ���ַ�����������ַ����ĵ�һ����ĸ��ԭ�ַ����е�λ����Ϊ���
��һ����ĸ���ڵ�λ����0
���ַ���alabala���������õ�7���ַ����������ã�
aalabal abalaal alaalab alabala balaala laalaba labalaa
��һ���ַ���Ϊaalabal�����a��ԭ�ַ���λ��Ϊ6����6Ϊ������ַ�����ͬʱ�������
����С�ģ�������aaaa���0��
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
      static const int MAXL=100000;
      static const int oo=256-1;
      typedef unsigned char string[MAXL+2];
      int L;
      string s;
      #define gc(i,j) (s[(i+j)%L])
      //gc(i,j)=ƫ���˵�i���ַ��´��ĵ�j���ַ� 
      public:
      Application(char* input,char* output)
                        :cin(input),cout(output)
      {
                        cin>>L;
                        for (int i=0;i<L;i++)
                            cin>>s[i];
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      int run()
      {
          int i=0,j=1;
          for (;j<=L;)
          {
              int k=0;
              for (;k<L-1;k++)
              {
                  if (gc(i,k)<gc(j,k))
                  {
                     j+=k+1;
                     if (j==i) j++;
                     break;
                  }
                  if (gc(i,k)>gc(j,k))
                  {
                     i+=k+1;
                     if (i==j) i++;
                     break;
                  }
              }
              if (k==L-1) j+=k+1;
              if (i>j)
              {
                 int swap=i;
                 i=j;
                 j=swap;
              }
          }
          cout<<i<<endl;
          return 0;
      }
      //force version
      /*
      bool impossible[MAXL+2];
      int run()
      {
          memset(impossible,false,sizeof(impossible));
          for (int j=0;j<L-1;j++)
          {
              int min=oo;
              int counter=0;
              int mins[MAXL+2];
              for (int i=1;i<=L;i++)
                  if (!impossible[i]) 
                  {
                     if (gc(i,j)<min)
                     {
                        for (int k=1;k<=counter;k++)
                            impossible[mins[k]]=true;
                        min=gc(i,j);
                        counter=1;
                        mins[counter]=i;
                     }
                     else if (gc(i,j)==min)
                     {
                        counter++;
                        mins[counter]=i;
                     }
                     else
                     {
                         impossible[i]=true;
                     }
                  }
              if (counter==1)
              {
                 cout<<mins[counter]<<endl;
                 break;
              }
          }
          return 0;
      }
      */
};

int main()
{
    Application app("hidden.in","hidden.out");
    return app.run();
}
