#include <iostream>
#include <string>
using namespace std;

//string 测试
#define TEXT
int main()
{
//测试代码
#ifdef TEXT
	//定义临时存储变量，类型为 char字符串
	char cstr[50];
	//定义字符串变量（string）
	string str[2];
	//定义交换变量（temp）
	string temp;

	//读取一行输入，读取后的结果存储到cstr，最大读取50-1位（因为要包括\0)
	//变量类型必须为char型字符串
	cin.getline(cstr, 2);

	//将读取到的内容存储给对应的变量
	str[0] = cstr;

	//修正代码，用于应对特殊情况
	//getline函数对于长度超过参数限定时就会自己设置一个无效位，
	//无效位后的文件内容就不会读取到
	//cin.clear();

	cin.getline(cstr, 2);
	str[1] = cstr;
	//cin.clear();

	cout << str[0] << endl;
	cout << str[1] << endl;
#endif

//实际代码
#ifndef TEXT
	char cstr[50];
	string str[2];
	string temp;

	cin.getline(cstr, 50);
	str[0] = cstr;
	cin.clear();

	cin.getline(cstr, 50);
	str[1] = cstr;
	cin.clear();

	if (str[1] > str[0]) {
		temp = str[0];
		str[0] = str[1];
		str[1] = temp;
	}

	cout << "string 1 = \" " << str[0] << " \"" << endl;
	cout << "string 2 = \" " << str[1] << " \"" << endl;
#endif
}