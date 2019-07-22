---
layout: post
type: note
title: "Linear Programming Notes"
color: teal
icon: fa-line-chart
date: 2019-07-21
categories:
  - omscs
  - graduate algorithms
  - linear programming
description:
  "Quick notes on linear programming, duality, and feasibility"
---
Typed version of some of my notes on Linear Programming for the [Graduate Algorithms](https://www.omscs.gatech.edu/cs-8803-ga-graduate-algorithms) course I am taking. Not formatted the best, but it gets the job done.

[Linear programming](https://en.wikipedia.org/wiki/Linear_programming) provides a way of describing and solving optimization problems via the use of linear functions.

## Standard Form of Primal LP

* **_max_ c<sup>T</sup>x**
* **_subject to_ Ax ≤ b**
* **_and_ x ≥ 0**

## Standard Form of Dual LP

* **_min_ b<sup>T</sup>y**
* **_subject to_ A<sup>T</sup>y ≥ c**
* **_and_ y ≥ 0**

## Example Primal LP

* **_max_ x<sub>1</sub> - 2x<sub>3</sub>**
* **x<sub>1</sub> - x<sub>2</sub> ≤ 1**
* **2x<sub>2</sub> - x<sub>3</sub> ≤ 1**
* **x<sub>1</sub>,x<sub>2</sub>,x<sub>3</sub> ≥ 0**

## Linear Algebra (Matrix) View of LP
We can view the Primal LP above as a series of matrices where _b_ is a vector containing the coefficients of the objective function, _A_ is a matrix containing the coefficients for each _x_ variable in each of the constraints (the omission of a variable in a constraint results in a 0), and _c_ is a vector containing the right-hand side value of each constraint inequality.

<div>
<img src="https://images.downey.io/linear-programming/lp-example-b.png" alt="The b vector of objective function coefficients">
</div>

<div>
<img src="https://images.downey.io/linear-programming/lp-example-A.png" alt="The A matrix of constraint coefficients">
</div>

<div>
<img src="https://images.downey.io/linear-programming/lp-example-c.png" alt="The c vector of inequality values">
</div>

## Finding Dual LP from Primal LP

My method for writing out the Dual LP:

Create a new variable _y_ for each condition (except for the ≥ 0 constraints)

The objective function for the Dual LP will consist of the right side of the inequalities of the Primal LP as the coefficients for each _y_. For example the Primal LP above has the following constraints:

* **x<sub>1</sub> - x<sub>2</sub> ≤ 1**
* **2x<sub>2</sub> - x<sub>3</sub> ≤ 1**

This would result in the following objective function for the Dual LP:
* **_min_ 1y<sub>1</sub> + 1y<sub>2</sub>**

Now we come up with the constraints for the Dual LP based on variables in the Primal LP. First let's do the left-hand side of the inequalities:

* **x<sub>1</sub> - x<sub>2</sub> ≤ 1**

Becomes

* **1x<sub>1</sub>y<sub>1</sub> - 1x<sub>2</sub>y<sub>1</sub>**

and

* **2x<sub>2</sub> - x<sub>3</sub> ≤ 1**

Becomes

* **2x<sub>2</sub>y<sub>2</sub> - 1x<sub>3</sub>y<sub>2</sub>**

Put these both together and we get:

* **1x<sub>1</sub>y<sub>1</sub> - 1x<sub>2</sub>y<sub>1</sub> + 2x<sub>2</sub>y<sub>2</sub> - 1x<sub>3</sub>y<sub>2</sub> ≥ 1y<sub>1</sub> + 1y<sub>2</sub>**

Now let's factor out the _x_ variables to create our constraints for our Dual LP.

* **x<sub>1</sub>(1y<sub>1</sub>) + x<sub>2</sub>(-1y<sub>1</sub> + 2y<sub>2</sub>) + x<sub>3</sub>(-1y<sub>2</sub>)**

We have three _x_ variables so we'll have three constraints. We'll use the coefficiences of the _x_ variables from the objective function of the Primal LP to use on the right-hand side of our Dual LP's inequalities.

* **x<sub>1</sub>(1y<sub>1</sub>)**

Will give us this inequality:

* **1y<sub>1</sub> ≥ 1**

And

* **x<sub>2</sub>(-1y<sub>1</sub> + 2y<sub>2</sub>)**

Will give us this inequality:

* **-1y<sub>1</sub> + 2y<sub>2</sub> ≥ 0 (zero because x<sub>2</sub> is not in the objective function)**

And

* **x<sub>3</sub>(-1y<sub>2</sub>)**

Will give us this inequality:

* **-1y<sub>2</sub> ≥ -2**

All in all this gives us the following Dual LP:

## Example Dual LP

* **_min_ 1y<sub>1</sub> + 1y<sub>2</sub>**
* **1y<sub>1</sub> ≥ 1**
* **-1y<sub>1</sub> + 2y<sub>2</sub> ≥ 0**
* **-1y<sub>2</sub> ≥ -2**
* **y<sub>1</sub>,y<sub>2</sub> ≥ 0**

## Converting LP into Standard (Canonical) Form
As you can see, the Dual LP above looks a bit different. It is minimizing instead of maximizing and using greater-than-or-equal-to instead of less-than-or-equal-to in its inequalities. We can convert it into standard for pretty simply, though.

Just multiply the objective function and both sides of the inequality by -1!

* **_max_ -1y<sub>1</sub> + -1y<sub>2</sub>**
* **-1y<sub>1</sub> ≤ -1**
* **1y<sub>1</sub> + -2y<sub>2</sub> ≤ 0**
* **1y<sub>2</sub> ≤ 2**
* **y<sub>1</sub>,y<sub>2</sub> ≥ 0**

## Determining if an LP is Infeasible
The **feasible region** of a linear program is the section of space where a valid point can lie. An LP is said to be infeasible when this feasible region is empty and therefore there is no valid assignment of its variables that can satisfy all of the LP's constraints.

For example, take the following LP:
* **_max_ x<sub>1</sub> + x<sub>2</sub>**
* **-1x<sub>1</sub> + -1x<sub>2</sub> ≤ -5**
* **1x<sub>1</sub> ≤ 1**
* **1x<sub>2</sub> ≤ 1**
* **x<sub>1</sub>,x<sub>2</sub> ≥ 0**

As you can probably tell, there is no way that we can have both x<sub>1</sub> and x<sub>2</sub> be both less than 1 **and** have their negated sum be less than 5. This LP is obviously infeasible. How can we programmatically determine this, though?

One was is by adding a new variable, _z_, to one of the constraints of our LP to create a new LP.

* **-1x<sub>1</sub> + -1x<sub>2</sub> + z ≤ -5**

_z_ can be anything we need it to be. It can be as low as necessary to make this constraint feasible. What we want to see, though, is if we can find value of _z_ such that **z ≥ 0**. If we can find one, this shows that _z_ is not contributing anything to satisfy the inequality and that the original inequality without it is satisfiable on its own. We can determine this by creating a new objective function to maximize _z_.

* **_max_ z**
* **-1x<sub>1</sub> + -1x<sub>2</sub> + z ≤ -5**
* **1x<sub>1</sub> ≤ 1**
* **1x<sub>2</sub> ≤ 1**
* **x<sub>1</sub>,x<sub>2</sub> ≥ 0**

Like I said earlier, if **z ≥ 0** then the original LP is feasible. If not, then the LP is infeasible. For the other constraints we could add additional variables to do the same (e.g. z<sub>1</sub>, z<sub>2</sub>, ...)

## Determining if an LP is Unbounded
A linear program is said to be **unbounded** if its objective function can be made arbitrarily large for maximization or small for minimization. How can we tell if an LP is unbounded?

We can use the Dual LP!

The Dual LP gives us an upper bound on the objective function of the Primal LP.

* **c<sup>T</sup>x ≤ b<sup>T</sup>y**

This is known as the **weak duality theorem**. Some facts from the theorem:

* If the Primal LP is **unbounded**, the Dual LP is **infeasible**
* If the Dual LP is **unbounded**, the Primal LP is **infeasible**
* If the Dual LP is **infeasible**, the Primal LP is either **unbounded** _or_ **infeasible**

We can use these facts to determine if our Primal LP is **unbounded** or not.

1. First check and see if the Primal LP is **infeasible** using the _z_ variable approach described above.
1. If it is **feasible** then find the Dual LP and check to see if it is **feasible** or not using the _z_ variable technique.
1. If the Dual LP is **infeasible** and we found our Primal LP to be **feasible** then we know the Primal LP must be **unbounded**. If the Dual LP is **feasible** then our Primal LP is **bounded**.

### Strong Duality Theorem

Primal LP is **feasible** and **bounded** _iff_ Dual LP is **feasible** and **bounded**

If there is an optimal point for the Primal then there is an optimal point for the Dual.
