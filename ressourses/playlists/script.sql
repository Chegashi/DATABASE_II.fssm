drop table if exists APPARTIENT;
drop table if exists MP3;
drop table if exists PLAYLIST;

create table MP3
(
numMp3 int PRIMARY KEY AUTO_INCREMENT,
nomMp3 varchar(64) NOT NULL
);

create table PLAYLIST
(
numPlaylist int PRIMARY KEY AUTO_INCREMENT,
nomPlaylist varchar(64) NOT NULL
);

create table APPARTIENT
(
numMp3 int,
numPlaylist int,
FOREIGN KEY (numMp3) REFERENCES MP3 (numMp3),
FOREIGN KEY (numPlaylist) REFERENCES PLAYLIST (numPlaylist),
PRIMARY KEY(numMp3, numPlaylist)
);

insert into MP3 (nomMp3) values ('Get Lucky'), ('Locked Down');
insert into PLAYLIST (nomPlaylist) values ('Soirée'), ('Voiture');
insert into APPARTIENT values (1, 1), (2, 1), (1, 2);
