# Euler Project Problems #5, 26

## Титульный лист

- Степутенко Илья, 368853.

### Problem 5: Smallest Multiple

#### Description

$2520$ is the smallest number that can be divided by each of the numbers from $1$ to $10$ without any remainder.

What is the smallest positive number that is evenly divisible by all of the numbers from $1$ to $20$?

#### Solution

Надо посчитать НОК для всех чисел от 1 до 20.

$$[a,b] = \frac{a \cdot b}{(a,b)}$$

Решение обобщается до последовательности $a_1, \dots, a_n$:

$$(a_1, \dots, a_n) = (a_1,(a_2, \dots, a_n))$$

$$[a_1, \dots, a_n] = [a_1, [a_2, \dots, a_n]]$$

Тогда будем последовательно считать НОК для всех чисел от 1 до 20.

Запустить классическое решение можно:

```shell
mix run_external_test lib/problem_5/external.sh
```

### Problem 26: Reciprocal cycles

#### Description

A unit fraction contains $1$ in the numerator. The decimal representation of the unit fractions with denominators $2$ to $10$ are given:

```
1/2 = 0.5
1/3 = 0.(3)
1/4 = 0.25
1/5 = 0.2
1/6 = 0.1(6)
1/7 = 0.(142857)
1/8 = 0.125
1/9 = 0.(1)
1/10 = 0.1
```

Where $0.1(6)$ means $0.166666\dots$, and has a 1-digit recurring cycle. It can be seen that $1/7$ has a 6-digit recurring cycle.

Find the value of $d < 1000$ for which $1/d$ contains the longest recurring cycle in its decimal fraction part.

#### Solution

Перебор чисел, нахождение длины периода дроби. Период дроби фиксируется по остатку, который начинает повторяться. Тогда достаточно сохранять уже собранные остатки и завершать поиск, когда остаток повторится. Повторить для каждого числа.

Запустить классическое решение можно:

```shell
mix run_external_test lib/problem_26/external.sh
```

### Методы реализации

Я использовал алгоритм Евклида для нахождения НОД, длинное деление для поиска периода дроби. Использовал разные реализации: простую рекурсию, хвостовую, list comprehension, итераторы, мапы. Некоторые реализации получались громоздкие, но такие условия реализации.

### Бенчмарки

| Name                        | ips     | average    | deviation  | median  | 99th %  |
|-----------------------------|---------|------------|------------|---------|---------|
| problem_5_tail_recursion    | 2.30 M  | 434.88 ns  | ±5034.30%  | 420 ns  | 500 ns  |
| problem_5_comprehension     | 1.56 M  | 640.28 ns  | ±3421.64%  | 610 ns  | 700 ns  |
| problem_5_mapping           | 1.28 M  | 778.69 ns  | ±3792.00%  | 680 ns  | 800 ns  |
| problem_5_simple_recursion  | 1.05 M  | 950.95 ns  | ±4489.74%  | 720 ns  | 980 ns  |
| problem_5_modular           | 0.70 M  | 1438.33 ns | ±3534.98%  | 980 ns  | 1720 ns |
| problem_26_tail_recursion   | 124.60  | 8.03 ms    | ±6.97%     | 7.71 ms | 9.13 ms |
| problem_26_comprehension    | 60.52   | 16.52 ms   | ±1.44%     | 16.57 ms| 16.98 ms|
| problem_26_mapping          | 59.81   | 16.72 ms   | ±3.34%     | 16.82 ms| 17.57 ms|
| problem_26_modular          | 58.68   | 17.04 ms   | ±3.16%     | 17.24 ms| 17.74 ms|
| problem_26_simple_recursion | 38.94   | 25.68 ms   | ±0.58%     | 25.72 ms| 25.97 ms|