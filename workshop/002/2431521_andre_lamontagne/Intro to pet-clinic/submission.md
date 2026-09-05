# Pet Clinic exploration Submission

**Name:** Andre Lamontagne

**Student ID:** 2431521

**Pet Clinic Domain:** Carts

## Exercise 1: Find a bug and a code smell or 3 code smells in your domain.

![alt text](CodeSmell1.png)

Instead of two if checks, you can use one simple condition and make it more reactive.

![alt text](CodeSmell2.png)

The comment should have been removed when the modification was made and it should have been marked as a TODO comment at first.

![alt text](CodeSmell3.png)

This file is way too big (less than 500 lines ideally).

![alt text](CodeSmell4.png)

CartProduct is built multiple times with almost the exact same fields. It could be a helper method.

## Exercise 2: Make a list of your domain's features.

**List of features:**

- add a product to your wish list.
- find, save and apply promo codes to your cart items.
- retrieve a list of recommended purchases.

## Exercise 3: Run a query on your domain's main table.

![alt text](query.png)

## Exercise 4: Look at the logs of your main service.

![alt text](logs.png)