/**  Joins and Relationships:  **/
-- Display the names of all tracks along with their corresponding album titles.
SELECT t.Name, a.Title FROM Track t JOIN Album a 
WHERE t.AlbumId = a.AlbumId;
-- List all artists along with their albums, showing all artists even if they don't have any albums.
SELECT ar.Name, al.Title FROM Artist ar LEFT JOIN Album al 
ON ar.ArtistId = al.ArtistId;
-- Show the names of all tracks along with the name of the artist who performed them.

-- Display all invoices along with the customer's name and email address, including invoices without associated customers.
-- Display all playlists along with the tracks they contain, even if there are playlists with no tracks.
-- List the names of all playlists along with the tracks they contain.
-- Show the names of all tracks along with their genre names.

/**  Aggregation and Grouping:  **/
-- Calculate the total number of tracks in each album.
-- Find the total number of invoices for each customer.
-- Calculate the total amount spent by each customer.
-- Find the average track length for each genre.
-- Determine the total number of tracks in each playlist.

/**  Subqueries and Advanced Queries:  **/
-- Find the names of customers who have made purchases in the USA.
-- Display the tracks with a duration over the average duration. Display the tracks duration in minutes.
-- List the names of all playlists containing tracks longer than 5 minutes.
-- Show the tracks with the highest unit price.

/**  Data Modification and Transactions:  **/
-- Insert a new customer into the `Customers` table.
-- Update the email address of a customer in the `Customers` table.
-- Insert a new invoice into the `Invoices` table.

/**  Correlated Queries:  **/
-- Find the tracks that have been included in playlists.
-- Find the total number of tracks in each genre with an average track length longer than that genre.

/**  Views:  **/
-- Create a view named v_album_sales that shows the total sales revenue for each album.
-- Create a view named v_high_spending_customers that displays customers who have spent more than $40 on purchases.
-- Create a view named v_track_sales that shows the total sales revenue for each track.
select * from PlaylistTrack
/**  Procedures:  **/
-- Develop a procedure named update_playlist to add tracks to a playlist. 
-- The procedure will require the track id and the playlist name. If the playlist name does not exist, create a new playlist with that name.
DELIMITER $
CREATE PROCEDURE update_playlist(IN track_id INT, IN list_name VARCHAR(120))
	BEGIN
		DECLARE list_id INT;
        DECLARE count INT;
        
        SELECT pl.list_id INTO list_id FROM Playlist pl WHERE list_name = pl.Name;
        IF list_id IS NULL THEN
			SELECT count(*) INTO count from Playlist;
            INSERT INTO Playlist(PlaylistId,Name) VALUES(count + 1, list_name);
        ELSE 
			INSERT INTO PlaylistTrack(PlaylistId,TrackId) VALUES(list_id, track_id);
		END IF;
	END $
DELIMITER ;

CALL update_playlist()