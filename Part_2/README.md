# Part 1
**Student:** Cristian Alexandru Catalin

**Group:** 312CC

---

## Tasks

| Task | Description |
|------|-----------|
| Task 1 | Dynamic vector (push, pop, get/set, print) |
| Task 2 | Reverse Polish Notation calculator |
| Task 3 | My own version of `printf` |
| Task 4 | Making Langford sequences with backtracking |
| Task 5 | Bonus: Operations , letter case, "heavy" numbers, matrix columns |

---

## Task 1 - Dynamic Vector

### `new_vector()`

- Makes the vector and, inside it, the array with the starting capacity given as parameter.
- Sets the length to `0` and the capacity to the value given.

### `set_element()`

- Compares the position with the vector's length.
- If it's out of bounds, prints the error and returns `-1`.
- If not, sets the value at that position and returns the position.

### `get_element()`

- Compares the position with the vector's length.
- If it's out of bounds, prints the error and returns `-1`.
- If not, returns the value found at that position.

### `push_element()`

- If the length reached the capacity, doubles the capacity with `realloc` before adding.
- Adds the value at the end and grows the length by one.

### `pop_element()`

- If the vector is empty, prints the error and returns `-1`.
- If not, takes out the last value, shrinks the length by one, and returns it.
- If the length gets to half the capacity, shrinks the vector with `realloc`.

### `print_vector()`

- Prints, in order, the values that are really stored (from `0` to `len`).
- Then prints the empty spots left (from `len` to `cap`), so the whole capacity is visible.
- At the end, prints the length and the capacity.

### `free_vector()`

- Frees the array, then frees the vector itself.
- Resets `len` and `cap` to `0` and sets the pointer to `NULL`.

---

## Task 2 - Reverse Polish Notation

### `reverse_polish_notation()`

- Reads the numbers and signs from `stdin`, line by line, using the program's own stack.
- If it reads `+`, `-`, `*` or `/`, takes the last two values, does the math, and pushes the result back.
- If it reads a number, turns it into a value with `atol` and pushes it.
- Keeps count (in `r14`) of how many values are on the stack, so it stays aligned to 16 bytes before every `call`.
- At the end, takes the final result off the stack and prints it.

---

## Task 3 - My Own `printf`

### `my_printf()`

- Goes through the format string character by character, with `r10` as offset and `r11` as the count of `%` found so far.
- If the character is not `%`, prints it right away with `putc`.
- If it's `%`, picks the matching argument based on `r11` (the first 5 come from `rsi`, `rdx`, `rcx`, `r8`, `r9`; the rest are read from the stack through `r14`, moving 8 bytes forward each time).
- Calls `select_type` to print the value, then moves the offset forward by however many characters that specifier took (returned in `rax`).

### `select_type()`

- Gets the letter after `%` (`d`, `s` or `c`) and calls the matching function: `print_type_d`, `print_type_s` or `print_type_c`.
- Returns in `rax` how many characters the specifier used up (`3` for `%ld`, `2` for `%s` and `%c`), so `my_printf` knows how far to move.

### `print_type_d()`

- Builds the text form of the number by dividing by `10` again and again, pushing each digit on the stack, starting from the last one.
- Once the number is fully turned into text, calls `print_type_s` to print it.

### `print_type_s()`

- Prints a string character by character, with `putc`, until it hits the null terminator.

### `print_type_c()`

- Prints one character straight from the value given, no extra work.

---

## Task 4 - Langford Sequences

### `check_langford()`

- Checks if a sequence is a Langford sequence: for every value `v`, its two copies must be exactly `v + 1` spots apart.
- For every `v` from `1` to `n/2`, finds where it first shows up, then checks the value `v + 1` spots later is also `v`.
- Returns `1` if this is true for all values, `0` if not.

### `malloc_pointers()`

- Makes the array that will hold the addresses of all the good sequences found.

### `backtrack()`

- Recursive function that tries, at each step, one of the numbers from `1` to `n/2` in the current spot.
- When the sequence reaches full length, calls `check_langford` to check it.
- If it's good, makes a new array, copies the sequence into it, and saves its address in the results array.

### `generate_langford_sequences()`

- Makes the results array and sets the count of sequences found to `0`.
- Calls `backtrack` starting from step `0` to try all sequences.
- Returns the array of good sequences found and, through the pointer given, how many there are.

---

## Task 5 - Bonus

### `ave()`

- Takes `'A'` away from the letter, adds `n` (kept in `r9`), then keeps subtracting `31` until the result is smaller than `31` - like a Caesar cipher - then adds `'A'` back.
- Writes the new letter into the destination string, until it hits the end of the source string.

### `switch_cases()`

- Goes through the string one letter at a time.
- If it's lowercase, turns it into uppercase (subtracts `32`).
- If it's uppercase, turns it into lowercase (adds `32`).
- If it's not a letter, copies it as it is - no change is made.

### `heavy()`

- Uses a mask (`0x80000000`) to check if the top bit of the number is set; if not, the number is not "heavy".
- If it is set, pulls out byte 3 and byte 4 with two masks, shifts them into place, and adds them together.
- If the sum is bigger than `255`, prints that the number is "heavy"; if not, prints that it's not.

### `flat_matrix()`

- The matrix is stored flat, row by row, so element `(i, j)` sits at index `i * n + j`.
- For each column, goes through all the rows to find the biggest value, starting from `-1`.
- Prints the biggest value found on each column.
