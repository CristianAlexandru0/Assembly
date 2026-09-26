# Part 1

**Student:** Cristian Alexandru Catalin

**Group:** 312CC

---

## Tasks

| Task | Description |
|------|-------------|
| Task 1 | Monaco Grand Prix - fixing the broken lap times |
| Task 2 | The Royal Labyrinth of Versailles - finding the way out of a maze |
| Task 3 | The London Airport Challenge - processing and sorting flights |
| Task 4 | Sudoku - checking rows, columns and boxes |

---

## Task 1 - Monaco Grand Prix

### `void fix_lap_times()`

- Goes through the lap times from the end to the start.
- Checks the error bit of each lap. If it's `0`, copies the value into the output vector.
- If it's `1`, counts it as an error and fixes the value:
  - first lap → takes the next lap's value.
  - last lap → takes the previous lap's value.
  - middle lap → takes the average of the previous and next lap.
- Reads the neighbours from the original vector, not the fixed one.
- At the end, writes the number of errors found.

---

## Task 2 - The Royal Labyrinth of Versailles

### `void solve_labyrinth()`

- Moves through the maze one spot at a time, starting from `(0, 0)`.
- At every step, checks in this order: down, up, right, left.
- Moves to the first free (`'0'`) and unvisited spot found.
- Marks the current spot with `1` before moving on.
- Stops when it reaches the last row or last column, and writes the exit's row and column.

---

## Task 3 - The London Airport Challenge

The flights are kept in an array of structures, like this:

```asm
struc flight
	destination:            resb 32
	departingTime_day:      resb 1
	departingTime_hour:     resb 1
	departingTime_minutes:  resb 1
	arrivingTime_day:       resb 1
	arrivingTime_hour:      resb 1
	arrivingTime_minutes:   resb 1
	bag_weight:              resw 1
	delayMinutes:           resb 1
	delayHours:             resb 1
endstruc
```

### `void apply_delay()`

- Runs the same steps twice: once for arrival time, once for departure time.
- Adds `delayMinutes` to the minutes; if it passes `60`, subtracts `60` and carries `1` to the hours.
- Adds `delayHours` plus the carry to the hours; if it passes `24`, subtracts `24` and carries `1` to the days.
- Adds the carry to the days.
- Moves to the next flight using `flight_size`.

### `void filter_flights()`

- Compares each flight's `bag_weight` with `min_bag_weight`.
- Skips the flight if the weight is too small.
- Copies the flight into the final array, byte by byte, if the weight is enough.
- Saves in `nrFlights` how many flights were kept.

### `int sort_and_return()`

- Sorts the flights in place, like selection sort.
- Compares by: arrival day, arrival hour, arrival minute, then bag weight.
- Swaps the two flights byte by byte when needed.
- After sorting, searches for a flight to the requested destination.
- Returns `1` and copies it into `bestFlight` if found, `0` if not.

---

## Task 4 - Sudoku

### `int check_row()`

- Computes the sum and the product of the row's elements.
- Compares the product with the factorial of `size`.
- Compares the sum with the Gauss sum of `size`.
- The row is valid only if both match.

### `int check_column()`

- Same as `check_row`, but reads down a fixed column instead of across a row.

### `int check_box()`

- Finds the box side (square root of `size`) and the factorial of `size`.
- Uses the box number to find the starting row and column.
- Computes the sum and product of the box's elements.
- The box is valid if the product matches the factorial and the sum matches the Gauss sum.
