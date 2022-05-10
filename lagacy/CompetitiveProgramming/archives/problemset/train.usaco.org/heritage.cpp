/*
ID: sujiao1
PROG: heritage
LANG: C++
*/
/*
PROGRAM: heritage
AUTHOR: Su Jiao
DATE: 2009-12-27
DESCRIPTION:
ũ��Լ���ǳ�����ضԴ�������ţ�ǵ�Ѫͳ��Ȼ��������һ����������ļ���Ա��������
����ţ�ǵļ������ɶ����������ҰѶ������Ը�����
�ġ���������������͡�����ǰ��������ķ��ż��Լ�¼��������ͼ�εķ�����
����������ڱ�������ţ���׵ġ�������������͡���ǰ��������ķ��ź󣬴�����ţ��
�׵ġ����ĺ���������ķ��š�ÿһͷ��ţ��������
��Ϊһ��Ψһ����ĸ����������Ѿ�֪���������֪���������ֱ����Ժ���Ծ������ؽ�
�����������Ȼ��������������ж���26���Ķ��㡣
�����������������������е�����ͼ�α�﷽ʽ��
                  C
                /   \
               /     \
              B       G
             / \     /
            A   D   H
               / \
              E   F
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
      string LDR;//IN-ORDER
      string DLR;//PRE-ORDER
      //string LRD;//POST-ORDER
      public:
      Application(char* input,char* output)
      :cin(input),cout(output)
      {
                              cin>>LDR>>DLR;
      }
      ~Application()
      {
                    cin.close();
                    cout.close();
      }
      void print(int is,int ie,int& ps,int& pe)
      {
           if (is>ie) return;
           char root=DLR[ps];
           ps++;
           int rp;
           for (int i=is;i<=ie;i++)
           {
               if (LDR[i]==root)
                  rp=i;
           }
           print(is,rp-1,ps,pe);
           print(rp+1,ie,ps,pe);
           cout<<root;
      }
      int run()
      {
          int s=0,e=DLR.length()-1;
          print(0,LDR.length()-1,s,e);
          cout<<endl;
          return 0;
      }
};

int main()
{
    Application app("heritage.in","heritage.out");
    return app.run();
}
