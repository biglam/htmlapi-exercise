
    1. Select the names of all users.

    SELECT name FROM users;


    2. Select the names of all shows that cost less than £15.

    SELECT name FROM shows WHERE "price" < 15;

    Le Haggis
    Paul Dabek Mischief
    Best of Burlesque
    Two become One
    Urinetown
    Two girls, one cup of comedy


    3. Select the names and prices of all shows, ordered by price in ascending order.

    SELECT name, price FROM shows ORDER BY price ASC;


    4. Select the average price of all shows.

    SELECT avg(price) FROM shows;

    15.9569230769231


    5. Select the price of the least expensive show.

    SELECT min(price) FROM shows;

    6.0


    6. Select the sum of the price of all shows.

    SELECT sum(price) FROM shows;

    207.44


    7. Select the sum of the price of all shows whose prices is less than £20.

    SELECT sum(price) FROM shows WHERE price < 20;

    142.45


    8. Select the name and price of the most expensive show.

    SELECT name, price FROM shows WHERE price = (SELECT max(price) FROM shows);

    or

    SELECT name, price FROM shows ORDER BY price DESC LIMIT 1;


    9. Select the name and price of the second from cheapest show.

    SELECT name, price FROM shows ORDER BY price ASC LIMIT 1 OFFSET 1;

    Best of Burlesque|7.99


    9. Select the time for the Edinburgh Royal Tattoo.

    SELECT time FROM times t JOIN shows s ON t.show_id = s.id WHERE s.name = 'Edinburgh Royal Tattoo';

    22:00


    10. Select the names of all users whose names start with the letter "N".

    SELECT name FROM users WHERE name like 'N%';


    12. Select the names of users whose names contain "mi".

    SELECT name FROM users WHERE name like '%mi%';


    13. Select the number of users who want to see "Shitfaced Shakespeare".

    SELECT count(show_id) FROM shows_users su JOIN shows s ON su.show_id = s.id WHERE s.name = 'Shitfaced Shakespeare';

    7


    14. Select all of the user names and the count of shows they're going to see.

    SELECT u.name, count(su.show_id) FROM users u JOIN shows_users su ON su.user_id = u.id GROUP BY u.id;

    or to include users not going to any shows

    SELECT u.name, count(su.show_id) FROM users u LEFT JOIN shows_users su ON su.user_id = u.id GROUP BY u.id;


    15. SELECT all users who are going to a show at 17:15.

    SELECT show_id FROM times WHERE time = '17:15';
    SELECT DISTINCT user_id FROM shows_users WHERE show_id IN (3, 6);
    SELECT name FROM users WHERE id IN (1, 3, 5, 8, 9, 13, 15, 11, 12, 16, 17);

    or

    SELECT u.name FROM users u JOIN shows_users su ON u.id = su.user_id JOIN times t ON su.show_id = t.show_id WHERE t.time = '17:15';


    16. Insert a user with the name "Antonio Goncalves" into the users table.

    INSERT INTO users (name) VALUES ('Antonio Goncalves');


    17. Select the id of the user with your name.

    SELECT id FROM users WHERE name = '<YOUR NAME!>';


    18. Insert a record that Antonio Goncalves wants to attend the show "Two girls, one cup of comedy".

    INSERT INTO shows_users (user_id, show_id) values ((SELECT id FROM users WHERE name = 'Antonio Goncalves'), (SELECT id FROM shows WHERE name = 'Two girls, one cup of comedy'));


    19. Updates the name of the "Antonio Goncalves" user to be "Tony Goncalves".

    UPDATE users SET name = 'Tony Goncalves' WHERE name = 'Antonio Goncalves';


    20. Deletes the user with the name 'Tony Goncalves'.

    DELETE FROM users WHERE name = 'Tony Goncalves';


    21. Deletes the shows for the user you just deleted.

    DELETE FROM shows_users WHERE user_id NOT IN (SELECT id FROM users);


