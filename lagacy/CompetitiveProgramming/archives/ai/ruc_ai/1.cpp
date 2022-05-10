/*
 * Package: StandardCodeLibrary.Core
 * */
//�������õ�ͷ�ļ���ʹ��std���ֿռ�
#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <utility>
#include <vector>
#include <list>
#include <string>
#include <stack>
#include <queue>
#include <deque>
#include <set>
#include <map>
#include <algorithm>
#include <functional>
#include <numeric>
#include <bitset>
#include <complex>
#include <cstdio>
#include <cstring>
#include <cmath>
#include <cstdlib>
#include <ctime>
#include <climits>
using namespace std;

//���ڼ��ٴ������ĺ�
#define lp for(;;)
#define repf(i,a,b) for (int i=(a);i<(b);++i)
#define rep(i,n) repf(i,0,n)
#define ft(i,a,b) for (int i=(a);i<=(b);++i)
#define fdt(i,a,b) for (int i=(a);i>=(b);--i)
#define fsubset(subset,set) for (int subset=(set)&((set)-1);subset;subset=(subset-1)&(set))
#define forin(i,charset) for (cstr i=(charset);*i;i++)
#define whl while
#define rtn return
#define fl(x,y) memset((x),char(y),sizeof(x))
#define clr(x) fl(x,char(0))
#define cpy(x,y) memcpy(x,y,sizeof(x))
#define sf scanf
#define pf printf
#define vec vector
#define pr pair
#define que queue
#define prq priority_queue
#define itr iterator
#define x first
#define y second
#define pb push_back
#define mp make_pair
#define ins insert
#define ers erase
#define lb lower_bound
#define ub upper_bound
#define rnk order_of_key
#define sel find_by_order
#define sz(x) (int((x).size()))
#define all(x) (x).begin(),(x).end()
#define srt(x) sort(all(x))
#define uniq(x) srt(x),(x).erase(unique(all(x)),(x).end())
#define rev(x) reverse(all(x))

//������صĺ�
#ifdef DEBUG
#define prt(x) cerr<<#x"="<<(x)<<endl
#define asrtWA(s) do if(!(s))do{cerr<<"assert("#s")"<<endl;}whl(0);whl(0)
#define asrtTLE(s) do if(!(s))do{cerr<<"assert("#s")"<<endl;}whl(0);whl(0)
#define asrtMLE(s) do if(!(s))do{cerr<<"assert("#s")"<<endl;}whl(0);whl(0)
#define asrtOLE(s) do if(!(s))do{cerr<<"assert("#s")"<<endl;}whl(0);whl(0)
#define asrtRE(s) do if(!(s))do{cerr<<"assert("#s")"<<endl;}whl(0);whl(0)
#define runtime() cerr<<"Used: "<<db(clock())/CLOCKS_PER_SEC<<"s"<<endl
#define input(in) do{}whl(0)
#define output(out) do{}whl(0)
#else
#define prt(x) (cerr)
#define asrtWA(s) do if(!(s))exit(0);whl(0)
#define asrtTLE(s) do if(!(s))whl(1);whl(0)
#define asrtMLE(s) do if(!(s))whl(new int);whl(0)
#define asrtOLE(s) do if(!(s))whl(1)puts("OLE");whl(0)
#define asrtRE(s) do if(!(s))*(int*)0=0;whl(0)
#define runtime() (cerr)
#define input(in) freopen(in,"r",stdin)
#define output(out) freopen(out,"w",stdout)
#endif

//������������
typedef long long int lli;
typedef double db;
typedef const char* cstr;
typedef string str;
typedef vec<int> vi;
typedef vec<vi> vvi;
typedef vec<bool> vb;
typedef vec<vb> vvb;
typedef vec<str> vs;
typedef pr<int,int> pii;
typedef pr<lli,lli> pll;
typedef pr<db,db> pdd;
typedef map<int,int> mii;
typedef map<str,int> msi;
typedef map<char,int> mci;
typedef set<int> si;
typedef set<str> ss;
typedef que<int> qi;
typedef vec<pii> vpii;
typedef vec<pdd> vpdd;

//���ó���:int�����ֵ;lli�����ֵ;db�������س���;ŷ������;Բ����;�ƶ�����;ȡģʹ�õĳ���
int oo=(~0u)>>1;
lli ooll=(~0ull)>>1;
db inf=1e+10;
db eps=1e-10;
db gam=0.5772156649015328606;
db pi=acos(-1.0);
int dx[]={1,0,-1,0,1,-1,-1,1,0};
int dy[]={0,1,0,-1,1,1,-1,-1,0};
int MOD=1000000007;

//���ú���:�����Сֵ����;��ѧ��غ���;��������;��״����;���鼯;�ɺϲ���;
template<typename type>inline bool cmax(type& a,const type& b){rtn a<b?a=b,true:false;}
template<typename type>inline bool cmin(type& a,const type& b){rtn b<a?a=b,true:false;}
template<typename type>inline type sqr(const type& x){rtn x*x;}
template<typename type>inline type mod(const type& x){rtn x%MOD;}
inline int sgn(const db& x){rtn (x>+eps)-(x<-eps);}
inline int dbcmp(const db& a,const db& b){rtn sgn(a-b);}
template<typename type>inline pr<type,type> operator-(const pr<type,type>& x){rtn mp(-x.x,-x.y);}
template<typename type>inline pr<type,type> operator+(const pr<type,type>& a,const pr<type,type>& b){rtn mp(a.x+b.x,a.y+b.y);}
template<typename type>inline pr<type,type> operator-(const pr<type,type>& a,const pr<type,type>& b){rtn mp(a.x-b.x,a.y-b.y);}
template<typename type>inline pr<type,type> operator*(const pr<type,type>& a,const type& b){rtn mp(a.x*b,a.y*b);}
template<typename type>inline pr<type,type> operator/(const pr<type,type>& a,const type& b){rtn mp(a.x/b,a.y/b);}
template<typename type>inline pr<type,type>& operator-=(pr<type,type>& a,const pr<type,type>& b){rtn a=a-b;}
template<typename type>inline pr<type,type>& operator+=(pr<type,type>& a,const pr<type,type>& b){rtn a=a+b;}
template<typename type>inline pr<type,type>& operator*=(pr<type,type>& a,const type& b){rtn a=a*b;}
template<typename type>inline pr<type,type>& operator/=(pr<type,type>& a,const type& b){rtn a=a/b;}
template<typename type>inline type cross(const pr<type,type>& a,const pr<type,type>& b){rtn a.x*b.y-a.y*b.x;}
template<typename type>inline type dot(const pr<type,type>& a,const pr<type,type>& b){rtn a.x*b.x+a.y*b.y;}
template<typename type>inline type gcd(type a,type b){if(b)whl((a%=b)&&(b%=a));rtn a+b;}
template<typename type>inline type lcm(type a,type b){rtn a*b/gcd(a,b);}
template<typename istream,typename first_type,typename second_type>inline istream& operator>>(istream& cin,pr<first_type,second_type>& x){rtn cin>>x.x>>x.y;}
template<typename ostream,typename first_type,typename second_type>inline ostream& operator<<(ostream& cout,const pr<first_type,second_type>& x){rtn cout<<x.x<<" "<<x.y;}
template<typename istream,typename type>inline istream& operator>>(istream& cin,vec<type>& x){rep(i,sz(x))cin>>x[i];rtn cin;}
template<typename ostream,typename type>inline ostream& operator<<(ostream& cout,const vec<type>& x){rep(i,sz(x))cout<<x[i]<<(i+1==sz(x)?"":" ");rtn cout;}
inline ostream& pdb(int prcs,db x){rtn cout<<setprecision(prcs)<<fixed<<(sgn(x)?(x):0);}
template<typename type>inline void bit_inc(vec<type>& st,int x,type inc){whl(x<sz(st))st[x]+=inc,x|=x+1;}
template<typename type>inline type bit_sum(const vec<type>& st,int x){type s=0;whl(x>=0)s+=st[x],x=(x&(x+1))-1;rtn s;}
template<typename type>inline type bit_kth(const vec<type>& st,int k){int x=0,y=0,z=0;whl((1<<(++y))<=sz(st));fdt(i,y-1,0){if((x+=1<<i)>sz(st)||z+st[x-1]>k)x-=1<<i;else z+=st[x-1];}rtn x;}
inline void make_set(vi& st){rep(i,sz(st))st[i]=i;}
inline int find_set(vi& st,int x){int y=x,z;whl(y!=st[y])y=st[y];whl(x!=st[x])z=st[x],st[x]=y,x=z;rtn y;}
inline bool union_set(vi& st,int a,int b){a=find_set(st,a),b=find_set(st,b);rtn a!=b?st[a]=b,true:false;}
template<typename type>inline void merge(type& a,type& b){if(sz(a)<sz(b))swap(a,b);whl(sz(b))a.ins(*b.begin()),b.ers(b.begin());}

//��ʼ��
struct Initializer{Initializer(){ios::sync_with_stdio(false);cin.tie(0);cout.tie(0);}~Initializer(){runtime();}}initializer;

//�Ǳ�׼
#define feach(e,s) for (__typeof__((s).begin()) e=(s).begin();e!=(s).end();++e)
#include <ext/rope>
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>
#include <ext/pb_ds/tag_and_trait.hpp>
using __gnu_cxx::rope;
template<typename key,typename value>class ext_map:public __gnu_pbds::tree<key,value,less<key>,__gnu_pbds::rb_tree_tag,__gnu_pbds::tree_order_statistics_node_update>{};

//2013-6-30 20:53
#include <stdio.h>
#include <stdlib.h>

struct Area {
    int terrain; //0Ϊ���أ�1Ϊɽ��
    int bonus; //����bonusֵ
    int belong; //0Ϊ�޹�����1Ϊ���һ��2Ϊ���2
    int soldier_num; //��������Ŀǰ��ʿ����Ŀ
    double value;
    int need;
};

int height, width; //��ͼ�ߺͿ�
int my_player_id; //�ҵ���ұ��
int attack_factor; //������ʧϵ��
int currentRound; //��ǰ�غ���
Area area[6][8]; //��ͼ

int soldier_num; //ÿ�غ��³��ֵ�ʿ��

//��ʼ����ͼ��Ϣ�;�����Ϣ
void init() {

    //��ȡ��������,�����(0,0)��ʼ
    scanf("%d%d", &height, &width);
    for (int i=0; i<height; i++) {
        for (int j=0; j<width; j++) {
            scanf("%d", &area[i][j].terrain);
        }
    }
    for (int i=0; i<height; i++) {
        for (int j=0; j<width; j++) {
            scanf("%d", &area[i][j].bonus);
        }
    }
    for (int i=0; i<height; i++) {
        for (int j=0; j<width; j++) {
            scanf("%d", &area[i][j].belong);
        }
    }

    //��ʼ������
    for (int i=0; i<height; i++) {
        for (int j=0; j<width; j++) {
            area[i][j].soldier_num = 0;
        }
    }
    currentRound = 0;

    scanf("%d%d", &my_player_id, &attack_factor);
}

//����bonus�ܺ�
int get_bonus(int player_id) {
    int bonus = 0;
    for (int i=0; i<height; i++) {
        for (int j=0; j<width; j++) {
            if (area[i][j].belong == player_id) {
                bonus += area[i][j].bonus;
            }
        }
    }
    return bonus;
}

//���һ�����Ƿ����
bool check_area(int x, int y) {
    return (x<height && y<width && x>=0 && y>=0 && area[x][y].terrain==0);
}

//����������Ƿ����ڣ�����Ϊ���������꣩
bool check_near(int x1, int y1, int x2, int y2) {
    int dx[]={0, 1, 0, -1};
    int dy[]={1, 0, -1, 0};
    for (int d=0; d<4; d++) {
        if (x1 + dx[d] == x2 && y1 + dy[d] == y2) return true;
    }
    return false;
}

//�����Ϸ�Ƿ����
bool check_end() {
    if (currentRound > 300) return true;

    //����Ƿ����п�����������ͬһ�����
    int player_id = -1;
    for (int i=0; i<height; i++) {
        for (int j=0; j<width; j++) {
            if (area[i][j].terrain == 0) {
                if (player_id == -1) player_id = area[i][j].belong;
                else if (area[i][j].belong != player_id) return false;
            }
        }
    }

    return true;
}

//����ʿ��
void set_soldier(int player_id, int x, int y, int number) {
    if (!check_area(x, y)) return ; //��������Ƿ�Ϸ�
    if (area[x][y].belong != player_id) return ; //��������Ƿ������Լ�
    area[x][y].soldier_num += number;

    //�Լ��ľ�����Ҫ��ӡ����
    if (player_id == my_player_id) {
        soldier_num -= number;
        printf("1 %d %d %d\n", x, y, number);
    }
}

//���й���
void attack(int player_id, int x1, int y1, int x2, int y2, int number) {
//    if (!check_area(x1, y1) || !check_area(x2, y2)) return ; //��������Ƿ�Ϸ�
//    if (area[x1][y1].belong != player_id || area[x2][y2].belong == player_id) return ; //�������Ĺ����Ƿ���ȷ
//    if (!check_near(x1, y1, x2, y2)) return ;
//    if (area[x1][y1].soldier_num < number) return ; //���ʿ�������Ƿ��㹻

    int A = number;
    int B = area[x2][y2].soldier_num;
    int S = area[x2][y2].bonus;
    int K = attack_factor;
    int C = (int)(K*B/10+S);
    if (A > C) { //�����ɹ�
        area[x2][y2].belong = player_id;
        area[x2][y2].soldier_num = A - C;
        area[x1][y1].soldier_num -= A;
    } else { //����ʧ��
        int D = (int)((A-1)*10/K);
        if (D > B) D = B;
        area[x2][y2].soldier_num -= D;
        area[x1][y1].soldier_num -= A;
    }

    //�Լ��ľ�����Ҫ��ӡ����
    if (player_id == my_player_id) {
        printf("2 %d %d %d %d %d\n", x1, y1, x2, y2, number);
    }
}

//������η���ʿ��
//���޸Ĵ˺����Խ��з���ʿ���ľ���
void set_all_soldier() {
    soldier_num = get_bonus(my_player_id);
    while (soldier_num > 0) {
        int dx[]={0, 1, 0, -1};
        int dy[]={1, 0, -1, 0};
        for (int i1=0; i1<height; i1++) {
            for (int j1=0; j1<width; j1++) {
                if (area[i1][j1].belong==my_player_id) { //�ҵ�һ�������Լ�������
                    for (int d=0; d<4; d++) {
                        int i2=i1+dx[d], j2=j1+dy[d];
                        if (check_area(i2, j2) && area[i2][j2].belong != my_player_id) { //����������в������Լ�������
                            if (soldier_num > 0) { //�ҵ�ǰʿ����������0
                                set_soldier(my_player_id, i1, j1, (rand() % soldier_num) + 1); //����ʿ��
                            }
                        }
                    }
                }
            }
        }
    }
}

//������ν���
//���޸Ĵ˺����Խ��н����ľ���
void do_all_attack() {
    bool is_attack;
    do {
        is_attack = false;
        int dx[]={0, 1, 0, -1};
        int dy[]={1, 0, -1, 0};
        for (int i1=0; i1<height; i1++) {
            for (int j1=0; j1<width; j1++) {
                if (area[i1][j1].belong==my_player_id && area[i1][j1].soldier_num > 0) { //�ҵ�һ�������Լ�����ʿ��������
                    for (int d=0; d<4; d++) {
                        int i2=i1+dx[d], j2=j1+dy[d];
                        if (check_area(i2, j2) && area[i2][j2].belong != my_player_id) { //����Ա��в������Լ�������
                            attack(my_player_id, i1, j1, i2, j2, area[i1][j1].soldier_num); //���ȥ
                            is_attack = true;
                            break;
                        }
                    }
                }
            }
            if (is_attack) break;
        }
    } while(is_attack); //ֱ�����ܽ����κι���Ϊֹ
}

//��ȡ���ֵĲ�����ά����ͼ״̬
void read_operator(int player_id) {
    while(true) {
        int type,x,y,x1,y1,x2,y2,number;
        scanf("%d", &type); //������
        if (type == -1) break;
        if (type == 1) {
            scanf("%d%d%d", &x, &y, &number);
            set_soldier(player_id, x, y, number); //����ʿ������
        } else if (type == 2) {
            scanf("%d%d%d%d%d", &x1, &y1, &x2, &y2, &number);
            attack(player_id, x1, y1, x2, y2, number); //��������
        }
    }
}

db my_factor(int d)
{
	static bool calced;
	//        0   1   2   3    4     5 ...
	db f[20]={1,0.5,0.4,0.3,0.15,0.075};
	if (!calced)
	{
		repf(i,4,20) f[i]=f[i-1]/2;
		calced=true;
	}
	rtn f[d];
}

void calc_value_and_need()
{
	rep(i,height) rep(j,width)
	{
		if (area[i][j].terrain==1)
		{
			area[i][j].value=-oo;
			area[i][j].need=+oo;
		}
		else
		{
			if (area[i][j].belong==my_player_id)
			{
				area[i][j].value=-oo;
				area[i][j].need=+oo;
			}
			else if (area[i][j].belong==3-my_player_id)
			{
				area[i][j].value=1.3*area[i][j].bonus+area[i][j].soldier_num;
			    int B = area[i][j].soldier_num;
			    int S = area[i][j].bonus;
			    int K = attack_factor;
			    int C = (int)(K*B/10+S);
				area[i][j].need=C;
			}
			else
			{
				area[i][j].value=1.2*area[i][j].bonus;
			    int B = area[i][j].soldier_num;
			    int S = area[i][j].bonus;
			    int K = attack_factor;
			    int C = (int)(K*B/10+S);
				area[i][j].need=C;
			}
		}
		//cerr<<i<<" "<<j<<":"<<area[i][j].need<<endl;
	}
	db nva[height][width];
	rep(i,height) rep(j,width)
	{
		db& nval=nva[i][j];
		nval=area[i][j].value-area[i][j].need;
//		prt(nval);
		int d[height][width];
		db value[height][width];
		fl(d,-1);
		queue<pii> q;
		q.push(mp(i,j));
		d[i][j]=0;
		value[i][j]=0;
		whl(sz(q))
		{
			int i=q.front().x;
			int j=q.front().y;
			nval+=d[i][j]?max(value[i][j],0.0)*my_factor(d[i][j])/d[i][j]:0;
			q.pop();
			rep(di,4)
			{
				int ni=i+dx[di];
				int nj=j+dy[di];
				if (check_area(ni,nj)&&d[ni][nj]==-1)
				{
					d[ni][nj]=d[i][j]+1;
					value[ni][nj]=value[i][j]+(area[ni][nj].value-area[ni][nj].need);
					q.push(mp(ni,nj));
				}
			}
		}
//		cerr<<db(nva[i][j]+100<0?0:nva[i][j])<<char(j==width-1?'\n':' ');
		area[i][j].value=nva[i][j];
	}
}
void go()
{
	calc_value_and_need();
    soldier_num = get_bonus(my_player_id);
    bool endpoint[height][width];
    clr(endpoint);
    int need=0;
    bool attacked[height][width];
    clr(attacked);
    vec<pr<pii,pii> > lst;
	int more=currentRound>10?2:1;
    whl(need<soldier_num)
    {
    	//cerr<<need<<":"<<soldier_num<<endl;
    	db max=-oo;
    	pr<pii,pii> atk;
		rep(i,height) rep(j,width) if (area[i][j].belong==my_player_id||attacked[i][j])
		{
			rep(di,4)
			{
				int ni=i+dx[di];
				int nj=j+dy[di];
				if (check_area(ni,nj)&&area[ni][nj].belong!=my_player_id&&!attacked[ni][nj])
				{
					if (cmax(max,area[ni][nj].value))
						atk=mp(mp(i,j),mp(ni,nj));
				}
			}
		}
		//cerr<<max<<endl;
		if (max!=-oo&&area[atk.y.x][atk.y.y].need!=+oo
				&&(area[atk.x.x][atk.x.y].belong==my_player_id||attacked[atk.x.x][atk.x.y])
				&&area[atk.y.x][atk.y.y].belong!=my_player_id&&!attacked[atk.y.x][atk.y.y])
		{
			int bnd=need;
			//prt(atk);
			//cerr<<area[atk.y.x][atk.y.y].need<<endl;
			need+=area[atk.y.x][atk.y.y].need+more;
			prt(area[atk.y.x][atk.y.y].need+more);
			attacked[atk.y.x][atk.y.y]=true;
			endpoint[atk.y.x][atk.y.y]=true;
			prt(atk.y);
			if (endpoint[atk.x.x][atk.x.y])
			{
				need-=more;
				if (need>soldier_num)
				{
					need=bnd;
					break;
				}
				endpoint[atk.x.x][atk.x.y]=false;
			}
			if (need>soldier_num)
			{
				need=bnd;
				break;
			}
			prt(bnd);
			prt(need);
			lst.pb(atk);
		}
		else break;
    }
//    prt(soldier_num);
//    prt(need);
    //rep(i,sz(lst)) prt(lst[i]);
    int nd[height][width];
    clr(nd);
    bool puted[height][width];
    clr(puted);
    fdt(i,sz(lst)-1,0)
    {
    	nd[lst[i].y.x][lst[i].y.y]+=area[lst[i].y.x][lst[i].y.y].need;
    	prt(endpoint[4][6]);
    	if (endpoint[lst[i].y.x][lst[i].y.y])
    	{
    		prt(lst[i].y);
    		prt("here");
    		//prt(soldier_num-need);
    		nd[lst[i].y.x][lst[i].y.y]+=more;
    	}
    	nd[lst[i].x.x][lst[i].x.y]+=nd[lst[i].y.x][lst[i].y.y];
    	if (!puted[lst[i].x.x][lst[i].x.y]&&area[lst[i].x.x][lst[i].x.y].belong==my_player_id)
    		nd[lst[i].x.x][lst[i].x.y]-=area[lst[i].x.x][lst[i].x.y].soldier_num,
    		need-=area[lst[i].x.x][lst[i].x.y].soldier_num,
    		puted[lst[i].x.x][lst[i].x.y]=true;
    	if (nd[lst[i].x.x][lst[i].x.y]<0)
    	{
    		prt(nd[lst[i].x.x][lst[i].x.y]);
    		need-=nd[lst[i].x.x][lst[i].x.y];
    		nd[lst[i].x.x][lst[i].x.y]=0;
    	}
    }
    fdt(i,sz(lst)-1,0)
    	if (endpoint[lst[i].y.x][lst[i].y.y])
    	{
    		nd[lst[i].y.x][lst[i].y.y]+=soldier_num-need;
    		whl(area[lst[i].x.x][lst[i].x.y].belong!=my_player_id)
    		{
        		nd[lst[i].x.x][lst[i].x.y]+=soldier_num-need;
        		prt(lst[i]);
        		prt(soldier_num-need);
    			rep(j,sz(lst))
				{
    				if (lst[j].y==lst[i].x)
    				{
    					i=j;
    					break;
    				}
				}
    		}
    		prt(nd[lst[i].x.x][lst[i].x.y]);
    		prt(lst[i].x);
    		prt(soldier_num-need);
    		nd[lst[i].x.x][lst[i].x.y]+=soldier_num-need;
    		need=soldier_num;
    		break;
    	}
    clr(puted);
    rep(i,sz(lst))
    	if (!puted[lst[i].x.x][lst[i].x.y]&&area[lst[i].x.x][lst[i].x.y].belong==my_player_id)
    		set_soldier(my_player_id,lst[i].x.x,lst[i].x.y,nd[lst[i].x.x][lst[i].x.y]),
    		puted[lst[i].x.x][lst[i].x.y]=true;
    rep(i,sz(lst))
    	attack(my_player_id,lst[i].x.x,lst[i].x.y,lst[i].y.x,lst[i].y.y,nd[lst[i].y.x][lst[i].y.y]);
    prt(soldier_num);
    prt(need);
}

int main() {
    init(); //��ʼ��
    int cur_player_id = 1;
    while (!check_end()) { //�����Ϸû�н���
        currentRound++;
        if (cur_player_id == my_player_id) {
            //�Լ��ж�
            //set_all_soldier(); //���з���ʿ������
            //do_all_attack(); //���й�������
        	go();
            printf("-1\n");
            fflush(stdout); //ע�⣡�˾���ÿ�غ���������ӣ���ˢ�»�������
        } else {
            //��ȡ�����ж�
            read_operator(cur_player_id);
        }
        if (cur_player_id == 1) cur_player_id = 2;
        else cur_player_id = 1; //�����ж���
    }
	return 0;
}