-- table of registered players
CREATE TABLE players ( name TEXT,
					   id SERIAL PRIMARY KEY);

-- table of match results
CREATE TABLE match_results ( winner_id INTEGER REFERENCES players(id), 
							 loser_id INTEGER REFERENCES players(id), 
							 tourney_id INTEGER);

-- view returns id and name of each registered player along with wins and matches played, ordered by most wins
CREATE VIEW standings AS WITH winners AS ( --temp table of total win count
							 SELECT p.id AS id, 
							  		p.name AS name, 
							  		count(w.winner_id) AS wins
						  	 FROM players p
						     LEFT JOIN match_results w ON w.winner_id = p.id
						     GROUP BY p.name, p.id
							 ), 
							losers AS ( --temp table of total loss count
							 SELECT p.id AS id, 
							  		p.name AS name, 
							  		count(l.loser_id) AS losses
						  	 FROM players p
						     LEFT JOIN match_results l ON l.loser_id = p.id
						     GROUP BY p.name, p.id
							) 
						 SELECT p.id AS id, 
								p.name AS name, 
								w.wins AS wins, --from above temp tables
								w.wins + l.losses AS matches --from above temp tables
						 FROM players p
						 		JOIN winners w ON w.id = p.id
						 		JOIN losers l ON l.id = p.id
						 GROUP BY p.name, p.id, w.wins, l.losses
						 ORDER BY wins DESC;