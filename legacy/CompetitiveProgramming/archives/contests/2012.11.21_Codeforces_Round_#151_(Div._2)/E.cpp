/*
 * Package: StandardCodeLibrary.Core
 * Last Update: 2012-11-22
 * */
#include <iostream>
#include <fstream>
#include <sstream>
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

#define lp for(;;)
#define repf(i,a,b) for (int i=(a);i<(b);++i)
#define rep(i,n) repf(i,0,n)
#define ft(i,a,b) for (int i=(a);i<=(b);++i)
#define fdt(i,a,b) for (int i=(a);i>=b;--i)
#define feach(e,s) for (typeof((s).begin()) e=(s).begin();e!=(s).end();++e)
#define fsubset(subset,set) for (int subset=set&(set-1);subset;subset=(subset-1)&set)
#define forin(i,charset) for (cstr i=charset;*i;i++)
#define whl while
#define rtn return
#define fl(x,y) fill((x),(x)+sizeof(x)/sizeof(*(x)),y)
#define clr(x) fl(x,0)
#define cpy(x,y) copy((y),(y)+sizeof(y)/sizeof(*(y)),(x))
#define pb push_back
#define mp make_pair
#define x first
#define y second
#define sz(x) ((int)(x).size())
#define all(x) (x).begin(),(x).end()
#define srt(x) sort(all(x))
#define uniq(x) srt(x),(x).erase(unique(all(x)),x.end());
#define vec vector
#define pr pair
#define que queue
#define prq priority_queue
#define itr iterator
#define sf scanf
#define pf printf
#define pdb(prcs,x) printf("%."#prcs"f",(abs(x)<1e-##prcs)?0.0:x)
#ifdef ONLINE_JUDGE
#define endl '\n'
#define prt(x) do{}whl(0)
#define asrtWA(s) do if(!(s))exit(0);whl(0)
#define asrtTLE(s) do if(!(s))whl(1);whl(0)
#define asrtMLE(s) do if(!(s))whl(new int);whl(0)
#define asrtOLE(s) do if(!(s))whl(1)puts("OLE");whl(0)
#define asrtRE(s) do if(!(s))*(int*)0=0;whl(0)
#define runtime() do{}whl(0)
#define input(in) freopen(in,"r",stin)
#define output(out) freopen(out,"w",stdout)
#else
#define prt(x) cerr<<#x<<"="<<(x)<<endl
#define asrtWA(s) do{}whl(0)
#define asrtTLE(s) do{}whl(0)
#define asrtMLE(s) do{}whl(0)
#define asrtOLE(s) do{}whl(0)
#define asrtRE(s) do{}whl(0)
#define runtime() cerr<<"Used: "<<db(clock())/CLOCKS_PER_SEC<<"s"<<endl
#define input(in) do{}whl(0)
#define output(out) do{}whl(0)
#define DEBUG
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
typedef pr<str,int> psi;
typedef map<int,int> mii;
typedef map<str,int> msi;
typedef map<char,int> mci;
typedef set<int> si;
typedef set<str> ss;
typedef que<int> qi;
typedef prq<int> pqi;

const int oo=(~0u)>>1;
const lli ooll=(~0ull)>>1;
const db inf=1e+20;
const db eps=1e-8;
const db pi=acos(-1.0);
const int MOD=1000000007;

template<typename type>inline bool cmax(type& a,const type& b){rtn a<b?a=b,true:false;}
template<typename type>inline bool cmin(type& a,const type& b){rtn b<a?a=b,true:false;}
template<typename type>inline type sqr(const type& x){rtn x*x;}
int dbcmp(const db& a,const db& b){rtn (a>b+eps)-(a<b-eps);}
int sgn(const db& x){rtn dbcmp(x,0);}
template<typename type>inline type gcd(type a,type b){if(b)whl((a%=b)&&(b%=a));rtn a+b;}
template<typename type>inline type lcm(type a,type b){rtn a*b/gcd(a,b);}
template<typename type>inline void bit_inc(vec<type>& st,int x,type inc){whl(x<sz(st))st[x]+=inc,x|=x+1;}
template<typename type>inline type bit_sum(const vec<type>& st,int x){type s=0;whl(x>=0)s+=st[x],x=(x&(x+1))-1;rtn s;}
template<typename type>inline type bit_kth(const vec<type>& st,int k){int x=0,y=0,z=0;whl((1<<(++y))<sz(st));fdt(i,y-1,0){if((x+=1<<i)>sz(st)||z+st[x-1]>k)x-=1<<i;else z+=st[x-1];}rtn x;}
inline void make_set(vi& set){rep(i,sz(set))set[i]=i;}
inline int find_set(vi& set,int x){int y=x,z;whl(y!=set[y])y=set[y];whl(x!=set[x])z=set[x],set[x]=y,x=z;rtn y;}
inline bool union_set(vi& set,int a,int b){a=find_set(set,a),b=find_set(set,b);rtn a!=b?set[a]=b,true:false;}
template<typename type>void merge(type& a,type& b){if(sz(a)<sz(b))swap(a,b);for(typename type::itr it=b.begin();it!=b.end();b.erase(it++))a.insert(*it);}
template<typename type>void merge(prq<type>& a,prq<type>& b){if(sz(a)<sz(b))swap(a,b);whl(sz(b))a.push(b.top()),b.pop();}

int n;
vvi adj;
vs name;
vi v,k;

msi id;
vvi q;
map<int,mii> ans;
map<int,vec<si> > dat;
void dfs(int u,int dp)
{
	vi cur(sz(q[u]));
	rep(i,sz(q[u])) cur[i]=sz(dat[dp+q[u][i]]);
	if (!id.count(name[u])) id.insert(mp(name[u],sz(id)));
	si st;
	st.insert(id[name[u]]);
	dat[dp].pb(st);
	rep(i,sz(adj[u])) dfs(adj[u][i],dp+1);
	rep(i,sz(q[u]))
	{
		whl(sz(dat[dp+q[u][i]])>cur[i]+1) merge(dat[dp+q[u][i]][cur[i]],dat[dp+q[u][i]].back()),dat[dp+q[u][i]].pop_back();
		dat[dp+q[u][i]].resize(cur[i]+1);
	}
	rep(i,sz(q[u])) ans[u][q[u][i]]=sz(dat[dp+q[u][i]][cur[i]]);
}
int main()
{
	ios::sync_with_stdio(false);
	cin>>n;
	adj=vvi(n+1);
	name=vs(n+1);
	ft(i,1,n)
	{
		int pi;
		cin>>name[i]>>pi;
		adj[pi].pb(i);
	}
	int m;
	cin>>m;
	v=vi(m),k=vi(m);
	q=vvi(n+1);
	rep(i,m)
	{
		cin>>v[i]>>k[i];
		q[v[i]].pb(k[i]);
	}
	dfs(0,0);
	rep(i,m) cout<<ans[v[i]][k[i]]<<endl;
}