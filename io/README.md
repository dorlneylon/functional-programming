# Io

## Лабораторная работа №3

- **Студент:** Степутенко Илья Сергеевич
- **Группа:** P3312
- **ИСУ:** 368823

---

**Цель:** получить навыки работы с вводом/выводом, потоковой обработкой данных, командной строкой.

- В рамках лабораторной работы вам предлагается повторно реализовать лабораторную работу по предмету "Вычислительная математика" посвящённую интерполяции (в разные годы это лабораторная работа 3 или 4) со следующими дополнениями:

- Обязательно должна быть реализована линейная интерполяция (отрезками, `link`);
настройки алгоритма интерполяции и выводимых данных должны задаваться через аргументы командной строки:

- Какие алгоритмы использовать (в том числе два сразу);
частота дискретизации результирующих данных;
и т.п.;


входные данные должны задаваться в текстовом формате на подобии `.csv` (к примеру `x;y\n` или `x\ty\n`) и подаваться на стандартный ввод, входные данные должны быть отсортированы по возрастанию `x`;

выходные данные должны подаваться на стандартный вывод;

программа должна работать в потоковом режиме (пример -- `cat | grep 11`), это значит, что при запуске программы она должна ожидать получения данных на стандартный ввод, и, по мере получения достаточного количества данных, должна выводить рассчитанные точки в стандартный вывод;

## Детали

1. **Структура проекта:**

   - Модульная организация с разделением на компоненты ввода/вывода и алгоритмы интерполяции
   - Асинхронная обработка данных через процессы `Elixir`
   - Потоковая обработка входных данных с поддержкой различных форматов разделителей

2. **Основные модули:**

   - `Io`: Основной модуль, обрабатывающий аргументы командной строки и инициализирующий процессы
   - `Io.Inputs`: Обработка входных данных и их трансляция алгоритмам
   - `Io.Cli.Outputs`: Форматированный вывод результатов
   - `Io.Cli.LinearInterpolation`: Линейная интерполяция
   - `Io.LagrangeInterpolation`: Интерполяция методом Лагранжа

3. **Ключевые функции:**

   - Парсинг аргументов командной строки (алгоритмы и частота)
   - Поддержка множественных форматов ввода (CSV-подобный с разделителями `,`, `;`, `\t`, пробел)
   - Параллельное выполнение нескольких алгоритмов интерполяции
   - Потоковый вывод результатов в реальном времени

4. **Алгоритмы интерполяции:**

   - **Линейная интерполяция:**
     - Работа с окном из двух точек
     - Вычисление промежуточных значений с заданной частотой
     - Округление результатов до 2 знаков после запятой

   - **Интерполяция Лагранжа:**
     - Использование окна до 5 точек
     - Полиномиальная интерполяция высокого порядка
     - Адаптивный шаг интерполяции

5. **Особенности реализации:**

   - Использование процессов Elixir для параллельной обработки
   - Неблокирующий ввод/вывод
   - Потоковая обработка данных без накопления в памяти
   - Поддержка различных форматов ввода
   - Возможность одновременного использования нескольких алгоритмов

## Релевантные части кода:

```elixir
  def main(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        switches: [
          algorithms: :string,
          frequency: :integer
        ],
        aliases: [
          a: :algorithms,
          f: :frequency
        ]
      )

    algorithms = parse_algorithms(opts[:algorithms] || "linear")
    frequency = opts[:frequency] || 1

    output_pid = spawn(Io.Cli.Outputs, :start, [])

    alg_pids =
      Enum.map(algorithms, fn alg ->
        case alg do
          :linear ->
            spawn(Io.Cli.LinearInterpolation, :start, [output_pid, frequency])

          :lagrange ->
            spawn(Io.LagrangeInterpolation, :start, [output_pid, frequency])

          _ ->
            IO.puts("Unknown algorithm: #{alg}")
            nil
        end
      end)
      |> Enum.filter(& &1)

    Io.Inputs.start(alg_pids)
  end
```



```elixir
  defp parse_line(line) do
    case String.trim(line) |> String.split(~r/[,\;\t\s]+/) do
      [x_str, y_str] ->
        with {x, ""} <- Float.parse(x_str),
             {y, ""} <- Float.parse(y_str) do
          {:ok, {x, y}}
        else
          _ -> {:error, "Invalid number format"}
        end

      _ ->
        {:error, "Invalid format"}
    end
  end
```



```elixir
  defp linear_interpolate({x1, y1}, {x2, y2}, freq) do
    step = 1.0 / freq
    xs = generate_steps(x1, x2, step)
    ys = Enum.map(xs, fn x -> y1 + (y2 - y1) / (x2 - x1) * (x - x1) end)

    %{
      xs: Enum.map(xs, &Float.round(&1, 2)),
      ys: Enum.map(ys, &Float.round(&1, 2))
    }
  end
```



```elixir
  defp lagrange_interpolate(points, freq) do
    {x_min, x_max} =
      points
      |> Enum.map(fn {x, _y} -> x end)
      |> Enum.min_max()

    step = 1.0 / freq
    xs = generate_steps(x_min, x_max, step)
    ys =
      Enum.map(xs, fn x ->
        lagrange(points, x)
      end)

    %{
      xs: Enum.map(xs, &Float.round(&1, 2)),
      ys: Enum.map(ys, &Float.round(&1, 2))
    }
  end
```

## Примеры использования

1. **Запуск с линейной интерполяцией:**

   ```bash
   ./io -a linear -f 1
   ```

2. **Запуск с обоими алгоритмами:**

   ```bash
   ./io -a "linear,lagrange" -f 2
   ```

3. **Пример входных данных:**

   ```text
   0 0.00
   1.571 1
   3.142 0
   4.712 -1
   12.568 0
   ```

4. **Пример вывода:**

   ```text
   Линейная:
   0.00    1.00    2.00
   0.00    0.64    1.27

   Лагранж:
   0.00    1.00    2.00    3.00    4.00
   0.00    0.97    0.84    0.12    -0.67


## Тесты

Реализованы модульные тесты для проверки корректности работы алгоритмов интерполяции:

1. **Линейная интерполяция:**

   ```elixir
      describe "LinearInterpolation" do
        test "interpolates two points correctly" do
          parent = self()
          pid = spawn(Io.LinearInterpolation, :start, [parent, 1])

          send(pid, {:point, {+0.0, +0.00}})
          send(pid, {:point, {1.571, +1.0}})
          send(pid, :eof)

          assert_receive {:output, "Линейная", [+0.00, +1.00, +2.00], [+0.00, +0.64, +1.27]}, 1000
        end

        test "interpolates non-integer steps correctly" do
          parent = self()
          pid = spawn(Io.LinearInterpolation, :start, [parent, 1])

          send(pid, {:point, {1.0, 2.0}})
          send(pid, {:point, {3.0, 4.0}})
          send(pid, :eof)

          assert_receive {:output, "Линейная", [1.00, 2.00, 3.00], [2.00, 3.00, 4.00]}, 1000
        end
      end

      describe "LagrangeInterpolation" do
        test "interpolates three points correctly" do
          parent = self()
          pid = spawn(Io.LagrangeInterpolation, :start, [parent, 1])

          send(pid, {:point, {+0.0, +0.00}})
          send(pid, {:point, {+1.0, +1.0}})
          send(pid, {:point, {+2.0, +0.0}})

          send(pid, :eof)

          assert_receive {:output, "Лагранж", [+0.00, +1.00, +2.00], [+0.00, +1.00, +0.00]}, 1000
        end

        test "interpolates five points correctly" do
          parent = self()
          pid = spawn(Io.LagrangeInterpolation, :start, [parent, 1])

          send(pid, {:point, {0.0, 0.00}})
          send(pid, {:point, {1.0, 1.00}})
          send(pid, {:point, {2.0, 0.00}})
          send(pid, {:point, {3.0, -1.00}})
          send(pid, {:point, {4.0, 0.00}})

          send(pid, :eof)

          expected_xs = [0.00, 1.00, 2.00, 3.00, 4.00]
          expected_ys = [0.00, 1.00, 0.00, -1.00, 0.00]

          assert_receive {:output, "Лагранж", ^expected_xs, ^expected_ys}, 1000
        end
      end
   ```

### Отчет инструмента тестирования

Тесты проверяют:

- Корректность интерполяции для двух точек (линейная)
- Правильность работы с нецелыми шагами
- Точность интерполяции Лагранжа для 3 и 5 точек

## Выводы

Я научился работать с входным/выходным потоком в Elixir.
