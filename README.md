# SoftwareQualityManagement

## Introduction

The aim of this software is to create a maintainability module using a number of software metrics.  The model will be used to analyse the maintainability of software systems written in Java. 

This software will apply visualisation techniques that give more insight into the software system under test (SUT)

## What metrics?

In this chapter we will mention which metrics we are going to measure. 

### .1 Volume

#### .1.1 Lines of Code

Heitlager *et al.* [1] define lines of code as all lines of code that are not comment or blank lines

#### .1.2 Number of Units

Heitlager *et al.* [1] points to a unit as the smallest piece of code that can be executed and tested individually. This is in Java a method. 

### .2 Size of each unit

The size of each unit is the Lines of Code (LOC) per unit.

### .3 Complexity of each unit

Cyclomatic complexity per unit

### .4 Duplication

Duplication is measured over 6 lines of code. Not taken the leading spaces into account. 

### .5 Unit test coverage (Optional)

### .6 Unit test quality

Amount of `assert` statements

## 

## Sources

[1] I. Heitlager, T. Kuipers and J. Visser, "A Practical Model for Measuring Maintainability - a preliminary report -" in *Proceedings of the 6th International Conference on Quality of Information and Communications Technology*, 2007, pp. 30-39. 

