// program to enter length and breadth from the usser of a rectangle and display area and parameter
#include <iostream>
using namespace std;
int main(){
    int length, breadth;
    cout << "Enter length of rectangle: ";
    cin >> length;
    cout << "Enter breadth of rectangle: ";
    cin >> breadth;
    int area = length * breadth;
    int perimeter = 2 * (length + breadth);
    cout << "Area of rectangle is: " << area << endl;
    cout << "Perimeter of rectangle is: " << perimeter << endl;
}