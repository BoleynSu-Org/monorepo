/*
 * Package: StandardCodeLibrary.Core
 * */
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
#if __GNUC__>=4 and __GNUC_MINOR__>=6
#include <ext/rope>
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>
#include <ext/pb_ds/tag_and_trait.hpp>
#endif
#ifdef  __GXX_EXPERIMENTAL_CXX0X__
#define typeof decltype
#endif
using namespace std;

#define lp for(;;)
#define repf(i,a,b) for (int i=(a);i<(b);++i)
#define rep(i,n) repf(i,0,n)
#define ft(i,a,b) for (int i=(a);i<=(b);++i)
#define fdt(i,a,b) for (int i=(a);i>=b;--i)
#define feach(e,s) for (typeof((s).begin()) e=(s).begin();e!=(s).end();++e)
#define fsubset(subset,set) for (int subset=(set)&((set)-1);subset;subset=(subset-1)&(set))
#define forin(i,charset) for (cstr i=(charset);*i;i++)
#define whl while
#define rtn return
#define fl(x,y) memset((x),char(y),sizeof(x))
#define clr(x) fl(x,char(0))
#define cpy(x,y) memcpy(x,y,sizeof(x))
#define pb push_back
#define mp make_pair
#define ins insert
#define ers erase
#define lb lower_bound
#define ub upper_bound
#define rnk order_of_key
#define sel find_by_order
#define x first
#define y second
#define sz(x) (int((x).size()))
#define all(x) (x).begin(),(x).end()
#define srt(x) sort(all(x))
#define uniq(x) srt(x),(x).erase(unique(all(x)),(x).end())
#define vec vector
#define pr pair
#define que queue
#define prq priority_queue
#define itr iterator
#define sf scanf
#define pf printf
#define pdb(prcs,x) (cout<<setprecision(prcs)<<fixed<<(sgn(x)?(x):0))
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
#define endl (char('\n'))
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
#if __GNUC__>=4 and __GNUC_MINOR__>=6
using __gnu_cxx::rope;
#endif
#if __GNUC__>=4 and __GNUC_MINOR__>=7
template<typename key,typename value>class ext_map:public __gnu_pbds::tree<key,value,less<key>,__gnu_pbds::rb_tree_tag,__gnu_pbds::tree_order_statistics_node_update>{};
template<typename key>class ext_set:public __gnu_pbds::tree<key,__gnu_pbds::null_type,less<key>,__gnu_pbds::rb_tree_tag,__gnu_pbds::tree_order_statistics_node_update>{};
#elif __GNUC__>=4 and __GNUC_MINOR__>=6
template<typename key,typename value>class ext_map:public __gnu_pbds::tree<key,value,less<key>,__gnu_pbds::rb_tree_tag,__gnu_pbds::tree_order_statistics_node_update>{};
template<typename key>class ext_set:public __gnu_pbds::tree<key,__gnu_pbds::null_mapped_type,less<key>,__gnu_pbds::rb_tree_tag,__gnu_pbds::tree_order_statistics_node_update>{};
#endif

int oo=(~0u)>>1;
lli ooll=(~0ull)>>1;
db inf=1e+10;
db eps=1e-10;
//db gamma=0.5772156649015328606;
db pi=acos(-1.0);
int dx[]={1,0,-1,0,1,-1,-1,1,0};
int dy[]={0,1,0,-1,1,1,-1,-1,0};
int MOD=1000000007;

template<typename type>inline bool cmax(type& a,const type& b){rtn a<b?a=b,true:false;}
template<typename type>inline bool cmin(type& a,const type& b){rtn b<a?a=b,true:false;}
template<typename type>inline type sqr(const type& x){rtn x*x;}
inline int sgn(const db& x){rtn (x>+eps)-(x<-eps);}
inline int dbcmp(const db& a,const db& b){rtn sgn(a-b);}
template<typename istream,typename first_type,typename second_type>inline istream& operator>>(istream& cin,pr<first_type,second_type>& x){rtn cin>>x.x>>x.y;}
template<typename ostream,typename first_type,typename second_type>inline ostream& operator<<(ostream& cout,const pr<first_type,second_type>& x){rtn cout<<x.x<<" "<<x.y;}
template<typename istream,typename type>inline istream& operator>>(istream& cin,vec<type>& x){rep(i,sz(x))cin>>x[i];rtn cin;}
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
template<typename type>inline void bit_inc(vec<type>& st,int x,type inc){whl(x<sz(st))st[x]+=inc,x|=x+1;}
template<typename type>inline type bit_sum(const vec<type>& st,int x){type s=0;whl(x>=0)s+=st[x],x=(x&(x+1))-1;rtn s;}
template<typename type>inline type bit_kth(const vec<type>& st,int k){int x=0,y=0,z=0;whl((1<<(++y))<=sz(st));fdt(i,y-1,0){if((x+=1<<i)>sz(st)||z+st[x-1]>k)x-=1<<i;else z+=st[x-1];}rtn x;}
inline void make_set(vi& st){rep(i,sz(st))st[i]=i;}
inline int find_set(vi& st,int x){int y=x,z;whl(y!=st[y])y=st[y];whl(x!=st[x])z=st[x],st[x]=y,x=z;rtn y;}
inline bool union_set(vi& st,int a,int b){a=find_set(st,a),b=find_set(st,b);rtn a!=b?st[a]=b,true:false;}
template<typename type>inline void merge(type& a,type& b){if(sz(a)<sz(b))swap(a,b);whl(sz(b))a.ins(*b.begin()),b.erase(b.begin());}

struct Initializer{Initializer(){ios::sync_with_stdio(false);cin.tie(0);cout.tie(0);}~Initializer(){runtime();}}initializer;

struct TeamContest
{
	static bool possible(int x,lli me,vec<lli> lst)
	{
		x--;
		rep(i,x)
		{
			lli get=lst[i]+lst[3*x-1-i*2];
			if (get<=me) return false;
		}
		return true;
	}
	static int worstRank(vector <int> strength)
	{
		lli me=max(max(strength[0],strength[1]),strength[2])+min(min(strength[0],strength[1]),strength[2]);
		vec<lli> lst;
		repf(i,3,sz(strength)) lst.pb(strength[i]);
		srt(lst);
		reverse(all(lst));
		int l=1,r=sz(strength)/3+1;
		whl(l+1!=r)
		{
			int mid=(l+r)>>1;
			if (possible(mid,me,lst)) l=mid;
			else r=mid;
		}
		return l;
	}
};
/*
 * Package: StandardCodeLibrary.GraphTheory.MinCostMaxFlow
 * Usage:
 * MAXV:需要为点分配多少空间,点只要在0到MAXV-1就可以了，即MAXV应该大于最大编号
 * MAXE:需要为边分配多少空间,一条边对应一条正向边和一条反向边，即MAXE要等于实际最大边数*2
 * build_graph:构图,详细见函数内的注释
 * add_edge:
 * 输入int u,v;flow_type c;cost_type d;
 * add_edge(u,v,c,d) 加一条u到v的容量为c代价为d的有向边,加一条v到u的容量为0代价为-d的有向边
 * min_cost_max_flow:
 * min_cost_max_flow(最大流,最小费用)
 * min_cost_max_flow_faster：
 * 输入bool has_negative_edges 初始图是否含有负权边
 * min_cost_max_flow_faster(最大流,最小费用,has_negative_edges)
 * */

namespace StandardCodeLibrary
{
namespace GraphTheory
{
namespace MinCostMaxFlow
{

const lli oo=0x7f7f7f7f7f7f7f7fll;
const int MAXE=1000000;
const int MAXV=10000;
typedef int flow_type;
typedef lli cost_type;
typedef struct struct_edge* edge;
struct struct_edge{int v;flow_type c;cost_type d;edge n,b;}pool[MAXE];
edge top;
int S,T;
edge adj[MAXV];
void build_graph(int s,int t)
{
	top=pool,clr(adj);
	S=s,T=t;//源,汇
	//add_edge(u,v,c,d);
}
void add_edge(int u,int v,flow_type c,cost_type d)
{
	top->v=v,top->c=c,top->d=d,top->n=adj[u],adj[u]=top++;
	top->v=u,top->c=0,top->d=-d,top->n=adj[v],adj[v]=top++;
	adj[u]->b=adj[v],adj[v]->b=adj[u];
	if (u==v) adj[u]->n->b=adj[u],adj[v]->b=adj[v]->n;//防止add_edge(u,u,c,d)时出现RE
}
cost_type d[MAXV];
int q[MAXV];
bool inq[MAXV];
int qh,qt;
edge p[MAXV];
void min_cost_max_flow(flow_type& flow,cost_type& cost)
{
	flow=0,cost=0;
	lp
	{
		fl(d,oo),inq[q[qh=qt=0]=S]=true,d[S]=0,p[S]=0;
		whl(qh<=qt)
		{
			int u=q[(qh++)%MAXV];
			inq[u]=false;
			for (edge i=adj[u];i;i=i->n)
				if (i->c&&cmin(d[i->v],d[u]+i->d))
				{
					p[i->v]=i;
					if (!inq[i->v]) inq[q[(++qt)%MAXV]=i->v]=true;
				}
		}
		if (d[T]==oo) break;
		else
		{
			flow_type delta=oo;
			for (edge i=p[T];i;i=p[i->b->v]) cmin(delta,i->c);
			for (edge i=p[T];i;i=p[i->b->v]) i->c-=delta,i->b->c+=delta,cost+=delta*i->d;
			flow+=delta;
		}
	}
}
int V=MAXV;
cost_type h[MAXV];
void min_cost_max_flow_faster(flow_type& flow,cost_type& cost,bool has_negative_edges=true)
{
	flow=0,cost=0;
	if (has_negative_edges)
	{
		fl(h,oo),fl(inq,false),qh=0,qt=-1;
		rep(i,V) h[i]=0,q[++qt]=i,inq[i]=true;
		whl(qh<=qt)
		{
			int u=q[(qh++)%MAXV];
			inq[u]=false;
			for (edge i=adj[u];i;i=i->n)
				if (i->c&&cmin(h[i->v],h[u]+i->d))
				{
					p[i->v]=i;
					if (!inq[i->v]) inq[q[(++qt)%MAXV]=i->v]=true;
				}
		}
	}
	else clr(h);
	lp
	{
		fl(d,oo),fl(inq,false);
		prq<pr<cost_type,int> > Q;
		d[S]=0,p[S]=0,Q.push(mp(-d[S],S));
		whl(sz(Q))
		{
			int u=Q.top().y;
			Q.pop();
			if (!inq[u])
			{
				inq[u]=true;
				for (edge i=adj[u];i;i=i->n)
				{
					if (i->c&&!inq[i->v]&&cmin(d[i->v],d[u]+i->d+h[u]-h[i->v]))
						p[i->v]=i,Q.push(mp(-d[i->v],i->v));
				}
			}
		}
		if (d[T]==oo) break;
		else
		{
			flow_type delta=oo;
			for (edge i=p[T];i;i=p[i->b->v]) cmin(delta,i->c);
			for (edge i=p[T];i;i=p[i->b->v]) i->c-=delta,i->b->c+=delta,cost+=delta*i->d;
			flow+=delta;
			rep(i,V) h[i]+=d[i];
		}
	}
}

}
}
}

struct SkiResorts
{
	static long long minCost(vector <string> road, vector <int> altitude)
	{
		using namespace StandardCodeLibrary::GraphTheory::MinCostMaxFlow;
		int n=sz(road);
		build_graph(sqr(n),sqr(n)+2);
		rep(i,n) rep(j,n) if (i!=j) if (road[i][j]=='Y')
		{
			rep(k,n) rep(l,n) if (altitude[k]>=altitude[l])
				add_edge(i*n+k,j*n+l,1,abs(altitude[l]-altitude[j]));
		}
		rep(i,n) add_edge(sqr(n),0*n+i,1,abs(altitude[i]-altitude[0]));
		rep(i,n) add_edge((n-1)*n+i,sqr(n)+1,1,0);
		add_edge(sqr(n)+1,sqr(n)+2,1,0);
		int flow;
		lli cost;
		min_cost_max_flow_faster(flow,cost,false);
		if (flow!=1) rtn -1;
		else rtn cost;
	}
};

//int main()
//{
//	prt(TeamContest::worstRank({3,9,4,6,2,6,1,6,9,1,4,1,3,8,5}));
//	prt(TeamContest::worstRank({53,47,88,79,99,75,28,54,65,14,22,13,11,31,43}));
//	prt(SkiResorts::minCost({"NNYNNYYYNN",
//		 "NNNNYNYNNN",
//		 "YNNNNYYNNN",
//		 "NNNNNNYNYY",
//		 "NYNNNNNNYY",
//		 "YNYNNNNYNN",
//		 "YYYYNNNYNN",
//		 "YNNNNYYNNN",
//		 "NNNYYNNNNN",
//		 "NNNYYNNNNN"},
//		{7, 4, 13, 2, 8, 1, 8, 15, 5, 15}));
//	prt(SkiResorts::minCost({"NNNNNNNNNNNNNYNYNNNNNNNYNNNNNYNYNNNYNNNNNNYNYNNNNN", "NNNNNNNNNNNNNYNNNYYYNNNNNNNYNNNNNNNNNNNNNNNNNNNNNN", "NNNNNNNNYNNNNNNNYNYNNNYYNNNNYNNNNNNNNYNYNYNNNNNNYN", "NNNNNNNNNNYYNNNNYYNNNNYNNNNNNNNYNNNNNNNNNNNNNNNYNN", "NNNNNNNNNNYYNNYNNNNNNYNYYNNYNNNYNYNNYNYYNYNNNNNNNN", "NNNNNNNYYYNNNYNNNNNYNYNNYNNNNNNYNNNNNNNYNNNNNNNNNN", "NNNNNNNNNNYNNNNNNYNNNNNNNYNNNNYYNNNNNNNNNNYNNNNNNN", "NNNNNYNNNYYNNYNNNNNYNNNNYNNNNNYNNNNNNNNNYNYYNYNNNN", "NNYNNYNNNYNNNYNNNNNNNNNNNNNNNNYNNNNYNYNNYNNNNYNNYN", "NNNNNYNYYNNYNNNNNNNYNYYNNNYYNNNNNYYNYNYNNNYNNNNNNN", "NNNYYNYYNNNNNNNNNNNNYNNNYYNYYNNYNNYYNNNNYNNNNNNNYN", "NNNYYNNNNYNNYNNNNNNNNNNYNNNNNYNYNYNNNNNNNYNNNNYNYN", "NNNNNNNNNNNYNNNNYNNNYYNYNNNNNNNYNYNYNNNNNNNYNNNNNN", "YYNNNYNYYNNNNNYNYYNNNYNYNNNNNYNNNYYNNYYYNNNNNNNNNN", "NNNNYNNNNNNNNYNNNNNNNYNNYYNNNNNNNNYYYNYNYYNNNNNYNN", "YNNNNNNNNNNNNNNNNNNNYNYYYNNNNNYNYNNNNNNNYNNNNNNNNN", "NNYYNNNNNNNNYYNNNYNNNYNNYYYNNNNNNNNNYNYYNNNNYYYNNN", "NYNYNNYNNNNNNYNNYNYNNNYYNNNNNYNNNNNYNYYNYNNNNNNNNN", "NYYNNNNNNNNNNNNNNYNNNNNYNNNNNNNNNNNNNYYNNNNNYNNNYN", "NYNNNYNYNYNNNNNNNNNNNNNNNNYNNNYNNNNNNNNYNNNYYNNNYN", "NNNNNNNNNNYNYNNYNNNNNNNNNNNNYNNNNNNYNNNYNNNNNNNNNN", "NNNNYYNNNYNNYYYNYNNNNNNYYNNNNNYNYNNNNNYYYNYNNNYNNN", "NNYYNNNNNYNNNNNYNYNNNNNYYNYNNNNNNNNNYYNYNYNNYNNYYN", "YNYNYNNNNNNYYYNYNYYNNYYNNNNYNYYNNNNYYYNNNYNNNNNNNN", "NNNNYYNYNNYNNNYYYNNNNYYNNNYNNNNNNYNNNYNNNNNNNNNNNN", "NNNNNNYNNNYNNNYNYNNNNNNNNNNNNNNNYNNNYNNNNNNYYYNNYN", "NNNNNNNNNYNNNNNNYNNYNNYNYNNNYNNNNYNNNNNYNNNNNNNYYN", "NYNNYNNNNYYNNNNNNNNNNNNYNNNNNYNYYYNNNNNNNNNYNNNNYN", "NNYNNNNNNNYNNNNNNNNNYNNNNNYNNNNYNYNNNNYNYNNNNNNNYN", "YNNNNNNNNNNYNYNNNYNNNNNYNNNYNNNNNNNNYYNNNNNYNYNNNN", "NNNNNNYYYNNNNNNYNNNYNYNYNNNNNNNNNNNNNYYNNNNNYNNNNN", "YNNYYYYNNNYYYNNNNNNNNNNNNNNYYNNNYNYNNNNYNNYNNNNNNN", "NNNNNNNNNNNNNNNYNNNNNYNNNYNYNNNYNNNNNNNYNNNNNYNNYN", "NNNNYNNNNYNYYYNNNNNNNNNNYNYYYNNNNNNNYNNNNNNNYYNYYN", "NNNNNNNNNYYNNYYNNNNNNNNNNNNNNNNYNNNNNYNYNYNYNNNYYN", "YNNNNNNNYNYNYNYNNYNNYNNYNNNNNNNNNNNNNNNNNNYNYYNNYY", "NNNNYNNNNYNNNNYNYNNNNNYYNYNNNYNNNYNNNNYYYNNNNNNYNY", "NNYNNNNNYNNNNYNNNYYNNNYYYNNNNYYNNNYNNNNYNNNNNNNYNY", "NNNNYNNNNYNNNYYNYYYNNYNNNNNNYNYNNNNNYNNNYNNNNYNYNN", "NNYNYYNNNNNNNYNNYNNYYYYNNNYNNNNYYNYNYYNNNNNYYNNNNY", "NNNNNNNYYNYNNNYYNYNNNYNNNNNNYNNNNNNNYNYNNNNNNNYNNN", "NNYNYNNNNNNYNNYNNNNNNNYYNNNNNNNNNNYNNNNNNNYNNNNYNN", "YNNNNNYYNYNNNNNNNNNNNYNNNNNNNNNYNNNYNNNNNYNNNNYNNY", "NNNNNNNYNNNNYNNNNNNYNNNNNYNYNYNNNNYNNNNYNNNNNNNNNN", "YNNNNNNNNNNNNNNNYNYYNNYNNYNNNNYNNYNYNNNYNNNNNNNNNN", "NNNNNNNYYNNNNNNNYNNNNNNNNYNNNYNNYYNYNNYNNNNNNNNYNN", "NNNNNNNNNNNYNNNNYNNNNYNNNNNNNNNNNNNNNNNNYNYNNNNNYN", "NNNYNNNNNNNNNNYNNNNNNNYNNNYNNNNNNYYNYYYNNYNNNYNNNN", "NNYNNNNNYNYYNNNNNNYYNNYNNYYYYNNNYYYYNNNNNNNNNNYNNN", "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNYYYNYNNYNNNNNNN"}, {836172203, 763103572, 375286927, 223444385, 801846573, 636393280, 321101866, 132628930, 667843532, 133709012, 347481312, 851887156, 965389874, 70582515, 330916248, 994770414, 596331113, 87184075, 402335450, 925903565, 214650739, 862304167, 50775571, 546623532, 714361379, 871741106, 529366380, 541195857, 458252593, 195721302, 337345677, 177529660, 770232947, 499893003, 713071940, 706459005, 343677621, 245358680, 391152500, 896774415, 400681017, 639030093, 9575561, 311749998, 466963292, 173097757, 994807632, 140629176, 218959704, 102021763}));
//}

lli minans;
char ans[100],cur[100];
void dfs(int i,lli get)
{
	if (i)
	{
		prt(cur[i+1]);
		cur[i]='+';
		dfs(i-1,get+lli(i)*i*i);
		cur[i]='-';
		dfs(i-1,get-lli(i)*i*i);
	}
	else if (cmin(minans,abs(get))) cpy(ans,cur);
}

int main()
{
	int n;
	whl(cin>>n)
	{
		lli get=0;
		fdt(i,n,21)
		{
			if (abs(get+lli(i)*i*i)<abs(get-lli(i)*i*i)) get+=lli(i)*i*i,putchar('+');
			else get-=lli(i)*i*i,putchar('-');
		}
		minans=oo;
		dfs(min(n,20),get);
		fdt(i,min(n,20),1) putchar(ans[i]);
		putchar('\n');
	}
}

































