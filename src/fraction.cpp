#include "fraction.h"

Fraction::Fraction()
{
	
}

Fraction::Fraction(int n, int d) :
	numerator(n),
	denominator(d)
{
	numeratorChanged();
	denominatorChanged();
	valueChanged();
}

Fraction::Fraction(const Fraction &other)
{
	numerator = other.numerator;
	denominator = other.denominator;
	
	numeratorChanged();
	denominatorChanged();
	valueChanged();
}

Fraction Fraction::simplified()
{
	int g = Math::gcd(numerator, denominator);
	return Fraction(numerator/g, denominator/g);
}

Fraction Fraction::copy()
{
	return *this;
}

bool Fraction::operator==(const Fraction &other)
{
	if (numerator == other.numerator && denominator == other.denominator)
		return true;
	else
	{
		if (isSimplified())
			return false;
	}
	
	return simplified() == other.simplified();
}

bool Fraction::isSimplified()
{
	return Math::gcd(numerator, denominator) == 1;
}
