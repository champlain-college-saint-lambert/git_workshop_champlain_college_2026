# Pet Clinic exploration Submission

**Name:** Thomas Angers

**Student ID:** 2430419

**Pet Clinic Domain:** Customer

## Exercise 1: Find a bug and a code smell or 3 code smells in your domain.



**Screenshot of the code smell:**
BadType.png
**Small description of the code smell:**
Comments say parameters should be different types from what they are. Probably meaning that when the code use those values later use the incorrect types are they always need to be converted.

**Screenshot of the code smell:**
RemovableMethod.png
**Small description of the code smell:**
As the comment says, this whole method is probably useless, but more than that, the comments says "probably" which means the code without that method was never tested and probably the old devloppers were afraid of deleting it.

**Screenshot of the code smell:**
TryCatch.png
**Small description of the code smell:**
They used a try catch in the validator instead of a lambda expression and they are just trying to catch any exceptions instead of a specific one which could lead to problems if that value is wrong we might not know why. This is even more true considering the fact that "Use meaningful error messages and custom exceptions" is one of the standards under the client service in the "java-coding-standards.md" doc.


Additional things that need fixing that I saw after:
EntirePageError.png



## Exercise 2: Make a list of your domain's features.

**List of features:**

- Can filter the list by any value
- Can upload photos for your profile or pet
- Can login to an admin account or user and have different priviledge

## Exercise 3: Run a query on your domain's main table.

Query-Customer.png

## Exercise 4: Look at the logs of your main service.

Log-Curstomer.png
