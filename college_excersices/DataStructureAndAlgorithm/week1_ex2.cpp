#include<iostream>
using namespace std;
int main(){
    string name;
    float basic_salary;
    cout << "Enter your name: ";
    cin >> name;
    cout << "Enter your basic salary: ";
    cin >> basic_salary;
    float tax;
    float net_salary;
    if (basic_salary>2000)
    {
        tax = basic_salary * 0.1;
        net_salary = basic_salary - tax;
    }
    else{
        tax = 0;
        net_salary = basic_salary;
    }
    cout << "Name:" << name << endl;
    cout << "Basic Salary:" << basic_salary << endl;
    cout << "Tax:" << tax << endl;
    cout << "Net Salary:" << net_salary << endl;
    
}