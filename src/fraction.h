#ifndef FRACTION_H
#define FRACTION_H

#include <QObject>

class Fraction
{
public:
	class Math
	{
	public:
		static int gcd(int m, int n)
		{
			return n == 0 ? m : gcd(n, m%n);
		}
	};
	
	int numerator = 0;
	int denominator = 1;
	
	Fraction();
	Fraction(int n, int d);
	Fraction(const Fraction &other);
	
	Fraction simplified();
	Fraction copy();
	
	bool operator== (const Fraction &other);
	bool isSimplified();
	
signals:
	void numeratorChanged();
	void denominatorChanged();
	void valueChanged();
	
};

#endif // FRACTION_H
