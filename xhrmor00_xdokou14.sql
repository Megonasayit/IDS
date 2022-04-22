DROP TABLE team_contains_clan;
DROP TABLE clan_focuses;
DROP TABLE team_participates_in_tournament;
DROP TABLE game_is_played_on_tournament;
DROP TABLE player_focuses;
DROP TABLE leader;
DROP TABLE player;
DROP TABLE game;
DROP TABLE match;
DROP TABLE tournament;
DROP TABLE clan;
DROP TABLE team;


CREATE TABLE clan
(
    id             INT PRIMARY KEY,
    name           VARCHAR(255) NOT NULL,
    anthem         VARCHAR(255) NOT NULL,
    origin_country VARCHAR(255) NOT NULL
);

CREATE TABLE team
(
    id   INT GENERATED AS IDENTITY PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE game
(
    id           INT GENERATED AS IDENTITY PRIMARY KEY,
    game_name    VARCHAR(255) NOT NULL,
    release_date DATE         NOT NULL,
    genres       VARCHAR(255) NOT NULL,
    game_modes   VARCHAR(255) NOT NULL,
    publisher    VARCHAR(255) NOT NULL
);


CREATE TABLE player
(
    birth_number INT PRIMARY KEY NOT NULL CHECK (MOD(birth_number, 11) = 0),
    full_name    VARCHAR(255)    NOT NULL,
    nick_name    VARCHAR(255)    NOT NULL,
    in_team REFERENCES team (id) ON DELETE CASCADE,
    in_clan REFERENCES clan (id) ON DELETE CASCADE
);


CREATE TABLE leader
(
    birth_number INT PRIMARY KEY REFERENCES player ON DELETE CASCADE
);

CREATE TABLE tournament
(
    id              INT GENERATED AS IDENTITY PRIMARY KEY,
    tournament_name VARCHAR(255) NOT NULL,
    company_name    VARCHAR(255) NOT NULL,
    main_prize      VARCHAR(255) NOT NULL,
    is_won REFERENCES team (id) ON DELETE CASCADE
);

CREATE TABLE match
(
    id              INT GENERATED AS IDENTITY PRIMARY KEY,
    match_date      DATE DEFAULT CURRENT_DATE NOT NULL,
    team_blue_score INT                       NOT NULL,
    team_red_score  INT                       NOT NULL,
    team_blue REFERENCES team (id) ON DELETE CASCADE,
    team_red REFERENCES team (id) ON DELETE CASCADE,
    is_in_tournament REFERENCES tournament (id) ON DELETE CASCADE
);

CREATE TABLE player_focuses
(
    game REFERENCES game (id) ON DELETE CASCADE,
    player REFERENCES player (birth_number) ON DELETE CASCADE,
    PRIMARY KEY (game, player)
);

CREATE TABLE clan_focuses
(
    clan REFERENCES clan (id) ON DELETE CASCADE,
    game REFERENCES game (id) ON DELETE CASCADE,
    PRIMARY KEY (clan, game)
);

CREATE TABLE team_participates_in_tournament
(
    tournament REFERENCES tournament (id) ON DELETE CASCADE,
    team REFERENCES team (id) ON DELETE CASCADE,
    PRIMARY KEY (tournament, team)
);


CREATE TABLE game_is_played_on_tournament
(
    tournament REFERENCES tournament (id) ON DELETE CASCADE,
    game REFERENCES game (id) ON DELETE CASCADE,
    PRIMARY KEY (tournament, game)
);

CREATE TABLE team_contains_clan
(
    clan REFERENCES clan (id) ON DELETE CASCADE,
    team REFERENCES team (id) ON DELETE CASCADE,
    PRIMARY KEY (clan, team)
);


DROP SEQUENCE ID_increment;
CREATE SEQUENCE ID_increment;
CREATE OR REPLACE TRIGGER create_clan
    BEFORE INSERT
    ON clan
    FOR EACH ROW
BEGIN
    if :NEW.ID is null then
        :NEW.ID := ID_increment.nextval;
    end if;
END;


INSERT INTO clan
VALUES (null, 'Ninjas In Pyjamas', 'Who We Are', 'Sweden');
INSERT INTO clan
VALUES (null, 'Team Liquid', 'Liquid', 'Netherlands');
INSERT INTO clan
VALUES (null, 'Virtus.pro', 'Virtus.pro', 'Russia');
INSERT INTO clan
VALUES (null, 'Fnatic', 'Fnatic', 'United Kingdom');
INSERT INTO clan
VALUES (null, 'FaZe Clan', 'FaZe Clan', 'United States');

INSERT INTO team (name)
VALUES ('Ninjas In Pyjamas');
INSERT INTO team (name)
VALUES ('Team Liquid');
INSERT INTO team (name)
VALUES ('Virtus.pro');
INSERT INTO team (name)
VALUES ('Fnatic');
INSERT INTO team (name)
VALUES ('FaZe Clan');

INSERT INTO game (game_name, release_date, genres, game_modes, publisher)
VALUES ('Fortnite',
        TO_DATE('2017-06-25', 'YYYY-MM-DD'),
        'PVE, PVP',
        'Battle Royale, Party Royale, Creative, Save the World',
        'Epic Games');

INSERT INTO game (game_name, release_date, genres, game_modes, publisher)
VALUES ('Counter-Strike: Global Offensive',
        TO_DATE('2017-08-22', 'YYYY-MM-DD'),
        'FPS',
        '5v5, 1v1',
        'Valve');
INSERT INTO game (game_name, release_date, genres, game_modes, publisher)
VALUES ('Valorant',
        TO_DATE('2020-06-02', 'YYYY-MM-DD'),
        'FPS',
        '5v5, 1v1',
        'Riot Games');
INSERT INTO game (game_name, release_date, genres, game_modes, publisher)
VALUES ('Minecraft',
        TO_DATE('2016-06-02', 'YYYY-MM-DD'),
        'FPS',
        '5v5, 1v1',
        'Mojang Studios');

INSERT INTO player
VALUES (7759251302, 'Ján Novák', 'JN', 1, 1);
INSERT INTO player
VALUES (8501234225, 'Fredrik Sterner', 'REZ', 1, 1);
INSERT INTO player
VALUES (8002154501, 'Nicolas Gonzalez Zamora', 'Plopski', 1, 1);
INSERT INTO player
VALUES (6602286911, 'Tim Jonasson', 'nawwk', 1, 1);
INSERT INTO player
VALUES (9407276065, 'Hampus Poser', 'hampus', 1, 1);
INSERT INTO player
VALUES (8409069251, 'Jiří Svoboda', 'JS', 2, 2);
INSERT INTO player
VALUES (6907282140, 'Keith Markovic', 'NAF', 2, 2);
INSERT INTO player
VALUES (0201270399, 'Jacky Yip', 'Stewie2K', 2, 2);
INSERT INTO player
VALUES (9311205288, 'Michael Wince', 'Grim', 2, 2);
INSERT INTO player
VALUES (9401028263, 'Gabriel Toledo', 'FalleN', 2, 2);
INSERT INTO player
VALUES (0209112178, 'Miroslav Procházka', 'MP', 3, 3);
INSERT INTO player
VALUES (8157217739, 'Jana Novotná', 'JA', 4, 4);

INSERT INTO leader
VALUES (7759251302);
INSERT INTO leader
VALUES (8409069251);
INSERT INTO leader
VALUES (0209112178);
INSERT INTO leader
VALUES (8157217739);

INSERT INTO tournament (tournament_name, company_name, main_prize, is_won)
VALUES ('Katowice Tournament', 'Valve', '7000000 €', 1);

INSERT INTO tournament (tournament_name, company_name, main_prize, is_won)
VALUES ('tournament 1',
        'Epic Games',
        'Sandwich',
        2);


INSERT INTO match (match_date, team_blue_score, team_red_score, team_blue, team_red, is_in_tournament)
VALUES (TO_DATE('2020-05-19', 'YYYY-MM-DD'),
        4,
        6,
        1,
        2,
        1);

INSERT INTO match (match_date, team_blue_score, team_red_score, team_blue, team_red, is_in_tournament)
VALUES (TO_DATE('2020-06-25', 'YYYY-MM-DD'),
        6,
        5,
        3,
        4,
        2);
INSERT INTO match (match_date, team_blue_score, team_red_score, team_blue, team_red, is_in_tournament)
VALUES (TO_DATE('2020-06-27', 'YYYY-MM-DD'),
        10,
        1,
        3,
        4,
        2);


INSERT INTO player_focuses
VALUES (2, 7759251302);
INSERT INTO player_focuses
VALUES (2, 8409069251);
INSERT INTO player_focuses
VALUES (1, 0209112178);
INSERT INTO player_focuses
VALUES (1, 8157217739);
INSERT INTO player_focuses
VALUES (3, 8157217739);

INSERT INTO clan_focuses
VALUES (1, 2);
INSERT INTO clan_focuses
VALUES (2, 2);
INSERT INTO clan_focuses
VALUES (3, 1);
INSERT INTO clan_focuses
VALUES (4, 1);

INSERT INTO team_participates_in_tournament
VALUES (1, 1);
INSERT INTO team_participates_in_tournament
VALUES (1, 2);
INSERT INTO team_participates_in_tournament
VALUES (2, 3);
INSERT INTO team_participates_in_tournament
VALUES (2, 4);

INSERT INTO game_is_played_on_tournament
VALUES (1, 2);
INSERT INTO game_is_played_on_tournament
VALUES (2, 1);

INSERT INTO team_contains_clan
VALUES (1, 1);
INSERT INTO team_contains_clan
VALUES (2, 2);
INSERT INTO team_contains_clan
VALUES (3, 3);
INSERT INTO team_contains_clan
VALUES (4, 4);
INSERT INTO team_contains_clan
VALUES (5, 5);

-- show all players of clan Ninjas In Pyjamas grouped by team that participated in Katowice Tournament and show tournaments company name
SELECT te.name, full_name, t.company_name
FROM PLAYER
         JOIN TEAM te ON in_team = te.id
         JOIN TEAM_PARTICIPATES_IN_TOURNAMENT tp ON in_team = tp.TEAM
         JOIN TOURNAMENT t ON t.ID = tp.TOURNAMENT
WHERE in_clan = 1
  AND tp.tournament = 1
GROUP BY te.id, te.name, FULL_NAME, t.company_name;

-- show game info from games that are played on tournaments
SELECT game_name, release_date, genres, game_modes, publisher
FROM GAME
WHERE EXISTS
          (SELECT GAME FROM GAME_IS_PLAYED_ON_TOURNAMENT)
;

-- show member count of all teams in descending order
SELECT /*+ INDEX(in_team player_index) */ name, COUNT(birth_number)
FROM team t
         LEFT JOIN player p ON t.id = p.in_team
GROUP BY name
ORDER BY COUNT(birth_number) DESC;
select *
from table ( DBMS_XPLAN.DISPLAY );

-- show only players that focus on games that no other player does (with given game name)
SELECT p.full_name, g.game_name
FROM player p
         JOIN player_focuses pf ON p.birth_number = pf.player
         JOIN game g ON pf.game = g.id
WHERE pf.game NOT IN (SELECT pf1.game
                      FROM player_focuses pf1
                      WHERE pf1.player != pf.player
);

-- show number of players that focus on each game
SELECT DISTINCT g.game_name, COUNT(player)
FROM PLAYER_FOCUSES
         RIGHT JOIN GAME g ON g.id = player_focuses.game
GROUP BY g.id, g.game_name
ORDER BY COUNT(player) DESC;

CREATE OR REPLACE TRIGGER update_clan
    BEFORE UPDATE of name
    ON CLAN
BEGIN
    if UPDATING THEN
        raise_application_error(-20001, 'Cannot update name');
    end if;
END;


DROP PROCEDURE print_clan_info;
CREATE PROCEDURE print_clan_info(
    p_clan_id NUMBER
)
    IS
    r_clan clan%ROWTYPE;
BEGIN
    SELECT *
    INTO r_clan
    FROM clan
    WHERE clan.id = p_clan_id;

    dbms_output.put_line('Clan name: ' || r_clan.name || ', clan anthem: ' || r_clan.anthem || ', clan country: ' ||
                         r_clan.origin_country);
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR');
end;

DROP PROCEDURE get_players_from_clan;
CREATE PROCEDURE get_players_from_clan(
    p_clan_id NUMBER
)
    IS
    c_birth_number player.birth_number%type;
    c_full_name    player.full_name%type;
    c_nick_name    player.nick_name%type;
    CURSOR c_player IS SELECT birth_number, full_name, nick_name
                       FROM player
                       WHERE player.in_clan = p_clan_id;
BEGIN
    OPEN c_player;
    LOOP
        FETCH c_player into c_birth_number, c_full_name, c_nick_name;
        EXIT WHEN c_player%notfound;
        dbms_output.put_line('Birth number: ' || c_birth_number || ', Full name: ' || c_full_name || ', Nick name: ' ||
                             c_nick_name);
    end loop;
    CLOSE c_player;
end;



drop index player_index;
create INDEX player_index ON player (in_team, birth_number);


-- show member count of all teams in descending order
EXPLAIN PLAN FOR
SELECT /*+ INDEX(in_team player_index) */ name, COUNT(birth_number)
FROM team t
         LEFT JOIN player p ON t.id = p.in_team
GROUP BY name
ORDER BY COUNT(birth_number) DESC;
select *
from table ( DBMS_XPLAN.DISPLAY );


-- view with member count of all teams in descending order
DROP MATERIALIZED VIEW members_counts_view;
CREATE MATERIALIZED VIEW members_counts_view
            BUILD IMMEDIATE
    REFRESH ON DEMAND
AS
SELECT name as jmeno, COUNT(birth_number) as pocet
FROM team t
         LEFT JOIN player p ON t.id = p.in_team
GROUP BY name
ORDER BY COUNT(birth_number) DESC;

DROP MATERIALIZED VIEW clans_view;
CREATE MATERIALIZED VIEW clans_view
            BUILD IMMEDIATE
    REFRESH ON COMMIT
AS
SELECT id, name
FROM clan;

--query for xhrmor00
SELECT * FROM clans_view;
SELECT * FROM members_counts_view;

GRANT SELECT ON members_counts_view to xhrmor00;
GRANT ALL PRIVILEGES ON clans_view to xhrmor00;
--REVOKE SELECT ON members_counts_view from xhrmor00;

GRANT SELECT ON player to xhrmor00;
GRANT UPDATE, INSERT on team TO xhrmor00;