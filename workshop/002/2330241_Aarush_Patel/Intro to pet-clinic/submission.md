# Pet Clinic exploration Submission

**Name:** [Aarush Patel]

**Student ID:** [2330241]

**Pet Clinic Domain:** [Products]

## Exercise 1: Find a bug and a code smell or 3 code smells in your domain.

**Screenshot of the code smell:**![Screenshot 2026-09-04 231702.png](Screenshot%202026-09-04%20231702.png)

**Small description of the code smell: The method DecreaseProductCount() is misleading because its name suggests that it decreases the number of available products. However, it changes requestCount using the value of productQuantity.
This makes the code confusing**

**Screenshot of the code smell:![Screenshot 2026-09-04 232218.png](Screenshot%202026-09-04%20232218.png)![Screenshot 2026-09-04 232200.png](Screenshot%202026-09-04%20232200.png)![Screenshot 2026-09-04 232207.png](Screenshot%202026-09-04%20232207.png)**

**Small description of the code smell: ProductServiceImpl is a God Class because it handles too many different responsibilities. It manages products, calculates ratings, interacts with product bundles, changes quantities, performs   
scheduled maintenance, and manages product types. This violates the Single Responsibility Principle**

**Screenshot of the code smell:**![Screenshot 2026-09-04 232441.png](Screenshot%202026-09-04%20232441.png)
![Screenshot 2026-09-04 232523.png](Screenshot%202026-09-04%20232523.png)

**Small description of the code smell: The same rating validation is repeated in both addRatingForProduct() and updateRatingForProduct(). Both methods verify that the rating exists, is between 1 and 5, and that the review contains   
fewer than 2,000 characters.**


## Exercise 2: Make a list of your domain's features.

**List of features:**

- feature 1 :  Track product price, track inventory quantity, Mark products as available or unavailable
- feature 2 :  Customers can add, view, update, and delete product ratings and reviews. Ratings must be between 1 and 5, and the service calculates each product’s average rating.
- feature 3 :  Users or administrators can create, view, update, and delete product bundles.

## Exercise 3: Run a query on your domain's main table.

**Screenshot of the query result:![Screenshot 2026-09-04 141737.png](Screenshot%202026-09-04%20141737.png)**

## Exercise 4: Look at the logs of your main service.

**Screenshot of logs: ![Screenshot 2026-09-04 141627.png](Screenshot%202026-09-04%20141627.png)**
