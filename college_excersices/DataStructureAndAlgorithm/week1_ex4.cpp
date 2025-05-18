#include <iostream>
using namespace std;
int main(){
    int max;
    int option;
    cout << "Enter 1 for odd numbers or 2 for even numbers: ";
    cin >> option;
    cout << "Enter the maximum number: ";
    cin >> max;
    switch (option)
    {
    case 1:
        for (int i = 1; i <= max; i+=2)
        {
            cout << i << " ";
        }
        cout << endl;
        break;
    
    case 2:
        for (int i = 2; i <= max; i+=2)
        {
            cout << i << " ";
        }
        cout << endl;
        break;
    
    default:
        break;
    }
}