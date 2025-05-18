#include <iostream>
using namespace std;
int main(){
    int age;
    cout << "Enter your age: ";
    cin >> age;
    if (age < 21)
    {
        cout << "You are too young." << endl;
    }
    else if (age >= 21 && age < 40)
    {
        cout << "You are young." << endl;
    }
    else if (age >= 40 && age < 60)
    {
        cout << "You are old." << endl;
    }
    else
    {
        cout << "You are too old." << endl;
    }
    
}