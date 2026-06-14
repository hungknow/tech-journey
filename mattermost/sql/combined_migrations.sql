-- server/channels/db/migrations/postgres/000001_create_teams.up.sql
CREATE TABLE IF NOT EXISTS teams (
    id VARCHAR(26) PRIMARY KEY,
    createat bigint,
    updateat bigint,
    deleteat bigint,
    displayname VARCHAR(64),
    name VARCHAR(64),
    description VARCHAR(255),
    email VARCHAR(128),
    type VARCHAR(255),
    companyname VARCHAR(64),
    alloweddomains VARCHAR(1000),
    inviteid VARCHAR(32),
    schemeid VARCHAR(26),
    UNIQUE(name)
);

CREATE INDEX IF NOT EXISTS idx_teams_invite_id ON teams (inviteid);
CREATE INDEX IF NOT EXISTS idx_teams_update_at ON teams (updateat);
CREATE INDEX IF NOT EXISTS idx_teams_create_at ON teams (createat);
CREATE INDEX IF NOT EXISTS idx_teams_delete_at ON teams (deleteat);
CREATE INDEX IF NOT EXISTS idx_teams_scheme_id ON teams (schemeid);

ALTER TABLE teams ADD COLUMN IF NOT EXISTS allowopeninvite boolean;
ALTER TABLE teams ADD COLUMN IF NOT EXISTS lastteamiconupdate bigint;
ALTER TABLE teams ADD COLUMN IF NOT EXISTS description VARCHAR(255);
ALTER TABLE teams ADD COLUMN IF NOT EXISTS groupconstrained boolean;

DROP INDEX IF EXISTS idx_teams_name;

DO $$
DECLARE 
    column_exist boolean := false;
BEGIN
SELECT count(*) != 0 INTO column_exist
    FROM information_schema.columns
    WHERE table_name = 'teams'
    AND table_schema = current_schema()
    AND column_name = 'alloweddomains'
    AND NOT data_type = 'varchar(1000)';
IF column_exist THEN
    ALTER TABLE teams ALTER COLUMN alloweddomains TYPE VARCHAR(1000);
END IF;
END $$;

DO $$
DECLARE 
    column_exist boolean := false;
BEGIN
SELECT count(*) != 0 INTO column_exist
    FROM information_schema.columns
    WHERE table_name = 'teams'
    AND table_schema = current_schema()
    AND column_name = 'groupconstrained'
    AND NOT data_type = 'boolean';
IF column_exist THEN
    ALTER TABLE teams ALTER COLUMN groupconstrained TYPE boolean;
END IF;
END $$;

DO $$
DECLARE 
    column_exist boolean := false;
BEGIN
SELECT count(*) != 0 INTO column_exist
    FROM information_schema.columns
    WHERE table_name = 'teams'
    AND table_schema = current_schema()
    AND column_name = 'type'
    AND NOT data_type = 'varchar(255)';
IF column_exist THEN
    ALTER TABLE teams ALTER COLUMN type TYPE VARCHAR(255);
END IF;
END $$;

DO $$
DECLARE 
    column_exist boolean := false;
BEGIN
SELECT count(*) != 0 INTO column_exist
    FROM information_schema.columns
    WHERE table_name = 'teams'
    AND table_schema = current_schema()
    AND column_name = 'schemeid'
    AND NOT data_type = 'varchar(26)';
IF column_exist THEN
    ALTER TABLE teams ALTER COLUMN schemeid TYPE varchar(26);
END IF;
END $$;

-- server/channels/db/migrations/postgres/000002_create_team_members.up.sql
CREATE TABLE IF NOT EXISTS teammembers (
    teamid VARCHAR(26) NOT NULL,
    userid VARCHAR(26) NOT NULL,
    roles VARCHAR(64),
    deleteat bigint,
    PRIMARY KEY (teamid, userid)
);

CREATE INDEX IF NOT EXISTS idx_teammembers_user_id ON TeamMembers (userid);
CREATE INDEX IF NOT EXISTS idx_teammembers_delete_at ON TeamMembers (deleteat);

ALTER TABLE teammembers ADD COLUMN IF NOT EXISTS schemeuser boolean;
ALTER TABLE teammembers ADD COLUMN IF NOT EXISTS schemeadmin boolean;
ALTER TABLE teammembers ADD COLUMN IF NOT EXISTS schemeguest boolean;
ALTER TABLE teammembers ADD COLUMN IF NOT EXISTS deleteat bigint;

DROP INDEX IF EXISTS idx_teammembers_team_id;

-- server/channels/db/migrations/postgres/000003_create_cluster_discovery.up.sql
CREATE TABLE IF NOT EXISTS clusterdiscovery (
    id VARCHAR(26) PRIMARY KEY,
    type VARCHAR(64),
    clustername VARCHAR(64),
    hostname VARCHAR(512),
    gossipport integer,
    port integer,
    createat bigint,
    lastpingat bigint
);

-- server/channels/db/migrations/postgres/000004_create_command_webhooks.up.sql
CREATE TABLE IF NOT EXISTS commandwebhooks (
    id VARCHAR(26) PRIMARY KEY,
    createat bigint,
    commandid VARCHAR(26),
    userid VARCHAR(26),
    channelid VARCHAR(26),
    rootid VARCHAR(26),
    parentid VARCHAR(26),
    usecount integer
);

CREATE INDEX IF NOT EXISTS idx_command_webhook_create_at ON commandwebhooks (createat);

-- server/channels/db/migrations/postgres/000005_create_compliances.up.sql
CREATE TABLE IF NOT EXISTS compliances (
    id VARCHAR(26) NOT NULL,
    createat bigint,
    userid VARCHAR(26),
    status VARCHAR(64),
    count integer,
    "desc" VARCHAR(512),
    type VARCHAR(64),
    startat bigint,
    endat bigint,
    keywords VARCHAR(512),
    emails VARCHAR(1024),
    PRIMARY KEY (id)
);

-- server/channels/db/migrations/postgres/000006_create_emojis.up.sql
CREATE TABLE IF NOT EXISTS emoji (
    id VARCHAR(26) PRIMARY KEY,
    createat bigint,
    updateat bigint,
    deleteat bigint,
    creatorid VARCHAR(26),
    name VARCHAR(64),
    UNIQUE(name, deleteat)
);

CREATE INDEX IF NOT EXISTS idx_emoji_update_at ON emoji (updateat);
CREATE INDEX IF NOT EXISTS idx_emoji_create_at ON emoji (createat);
CREATE INDEX IF NOT EXISTS idx_emoji_delete_at ON emoji (deleteat);

DROP INDEX IF EXISTS Name_2;

DROP INDEX IF EXISTS idx_emoji_name;

-- server/channels/db/migrations/postgres/000007_create_user_groups.up.sql
CREATE TABLE IF NOT EXISTS usergroups (
    id VARCHAR(26) PRIMARY KEY,
    name VARCHAR(64),
    displayname VARCHAR(128),
    description VARCHAR(1024),
    source VARCHAR(64),
    remoteid VARCHAR(48),
    createat bigint,
    updateat bigint,
    deleteat bigint,
    allowreference bool,
    UNIQUE(name),
    UNIQUE(source, remoteid)
);

ALTER TABLE usergroups ADD COLUMN IF NOT EXISTS allowreference bool;
CREATE INDEX IF NOT EXISTS idx_usergroups_remote_id ON usergroups (remoteid);
CREATE INDEX IF NOT EXISTS idx_usergroups_delete_at ON usergroups (deleteat);

-- server/channels/db/migrations/postgres/000008_create_group_members.up.sql
CREATE TABLE IF NOT EXISTS groupmembers (
    groupid VARCHAR(26),
    userid VARCHAR(26),
    createat bigint,
    deleteat bigint,
    PRIMARY KEY(groupid, userid)
);

CREATE INDEX IF NOT EXISTS idx_groupmembers_create_at ON groupmembers (createat);

-- server/channels/db/migrations/postgres/000009_create_group_teams.up.sql
CREATE TABLE IF NOT EXISTS groupteams (
    groupid VARCHAR(26),
    autoadd boolean,
    schemeadmin boolean,
    createat bigint,
    deleteat bigint,
    updateat bigint,
    teamid VARCHAR(26),
    PRIMARY KEY(groupid, teamid)
);

ALTER TABLE groupteams ADD COLUMN IF NOT EXISTS schemeadmin boolean default false;

CREATE INDEX IF NOT EXISTS idx_groupteams_schemeadmin ON groupteams (schemeadmin);
CREATE INDEX IF NOT EXISTS idx_groupteams_teamid ON groupteams (teamid);

-- server/channels/db/migrations/postgres/000010_create_group_channels.up.sql
CREATE TABLE IF NOT EXISTS groupchannels (
    groupid VARCHAR(26),
    autoadd boolean,
    schemeadmin boolean,
    createat bigint,
    deleteat bigint,
    updateat bigint,
    channelid VARCHAR(26),
    PRIMARY KEY(groupid, channelid)
);

ALTER TABLE groupchannels ADD COLUMN IF NOT EXISTS schemeadmin boolean;

CREATE INDEX IF NOT EXISTS idx_groupteams_schemeadmin ON groupchannels (schemeadmin);
CREATE INDEX IF NOT EXISTS idx_groupchannels_channelid ON groupchannels (channelid);

-- server/channels/db/migrations/postgres/000011_create_link_metadata.up.sql
CREATE TABLE IF NOT EXISTS linkmetadata (
    hash bigint NOT NULL,
    url VARCHAR(2048),
    "timestamp" bigint,
    type VARCHAR(16),
    data VARCHAR(4096),
    PRIMARY KEY (hash)
);

CREATE INDEX IF NOT EXISTS idx_link_metadata_url_timestamp ON linkmetadata (url, "timestamp");

-- server/channels/db/migrations/postgres/000012_create_commands.up.sql
CREATE TABLE IF NOT EXISTS commands (
    id VARCHAR(26) PRIMARY KEY,
    token VARCHAR(26),
    createat bigint,
    updateat bigint,
    deleteat bigint,
    creatorid VARCHAR(26),
    teamid VARCHAR(26),
    trigger VARCHAR(128),
    method VARCHAR(1),
    username VARCHAR(64),
    iconurl VARCHAR(1024),
    autocomplete bool,
    autocompletedesc VARCHAR(1024),
    autocompletehint VARCHAR(1024),
    displayname VARCHAR(64),
    description VARCHAR(128),
    url VARCHAR(1024)
);

CREATE INDEX IF NOT EXISTS idx_command_team_id ON commands (teamid);
CREATE INDEX IF NOT EXISTS idx_command_update_at ON commands (updateat);
CREATE INDEX IF NOT EXISTS idx_command_create_at ON commands (createat);
CREATE INDEX IF NOT EXISTS idx_command_delete_at ON commands (deleteat);

ALTER TABLE commands ADD COLUMN IF NOT EXISTS pluginid VARCHAR(190);

UPDATE commands SET pluginid = '' WHERE pluginid IS NULL;

-- server/channels/db/migrations/postgres/000013_create_incoming_webhooks.up.sql
CREATE TABLE IF NOT EXISTS incomingwebhooks (
    id VARCHAR(26) PRIMARY KEY,
    createat bigint,
    updateat bigint,
    deleteat bigint,
    userid VARCHAR(26),
    channelid VARCHAR(26),
    teamid VARCHAR(26),
    displayname VARCHAR(64),
    description VARCHAR(128)
);

CREATE INDEX IF NOT EXISTS idx_incoming_webhook_user_id ON incomingwebhooks (userid);
CREATE INDEX IF NOT EXISTS idx_incoming_webhook_team_id ON incomingwebhooks (teamid);
CREATE INDEX IF NOT EXISTS idx_incoming_webhook_update_at ON incomingwebhooks (updateat);
CREATE INDEX IF NOT EXISTS idx_incoming_webhook_create_at ON incomingwebhooks (createat);
CREATE INDEX IF NOT EXISTS idx_incoming_webhook_delete_at ON incomingwebhooks (deleteat);

ALTER TABLE incomingwebhooks ADD COLUMN IF NOT EXISTS username VARCHAR(255);
ALTER TABLE incomingwebhooks ADD COLUMN IF NOT EXISTS iconurl VARCHAR(1024);
ALTER TABLE incomingwebhooks ADD COLUMN IF NOT EXISTS channellocked boolean;
ALTER TABLE incomingwebhooks ALTER COLUMN description TYPE VARCHAR(500);

DO $$
<<checks>>
DECLARE
    wrong_usernames_count integer := 0;
    wrong_icon_urls_count integer := 0;
BEGIN
    SELECT COALESCE(
        SUM(
            CASE
            WHEN CHAR_LENGTH(username) > 255 THEN 1
            ELSE 0
            END
        ),
    0) INTO wrong_usernames_count
    FROM incomingwebhooks;

    SELECT COALESCE(
        SUM(
            CASE
            WHEN CHAR_LENGTH(iconurl) > 1024 THEN 1
            ELSE 0
            END
        ),
    0) INTO wrong_icon_urls_count
    FROM incomingwebhooks;

    IF wrong_usernames_count > 0 THEN
        RAISE EXCEPTION 'IncomingWebhooks column Username has data larger that 255 characters';
    END IF;

    IF wrong_icon_urls_count > 0 THEN
            RAISE EXCEPTION 'IncomingWebhooks column IconURL has data larger that 1024 characters';
    END IF;
END checks $$;

DO $$
DECLARE 
    column_exist boolean := false;
BEGIN
SELECT count(*) != 0 INTO column_exist
    FROM information_schema.columns
    WHERE table_name = 'incomingwebhooks'
    AND table_schema = current_schema()
    AND column_name = 'description'
    AND NOT data_type = 'VARCHAR(500)';
IF column_exist THEN
    ALTER TABLE incomingwebhooks ALTER COLUMN description TYPE VARCHAR(500);
END IF;
END $$;

-- server/channels/db/migrations/postgres/000014_create_outgoing_webhooks.up.sql
CREATE TABLE IF NOT EXISTS outgoingwebhooks (
    id VARCHAR(26) PRIMARY KEY,
    token VARCHAR(26),
    createat bigint,
    updateat bigint,
    deleteat bigint,
    creatorid VARCHAR(26),
    channelid VARCHAR(26),
    teamid VARCHAR(26),
    triggerwords VARCHAR(1024),
    callbackurls VARCHAR(1024),
    displayname VARCHAR(64)
);

ALTER TABLE outgoingwebhooks ADD COLUMN IF NOT EXISTS contenttype VARCHAR(128);
ALTER TABLE outgoingwebhooks ADD COLUMN IF NOT EXISTS triggerwhen integer;
ALTER TABLE outgoingwebhooks ADD COLUMN IF NOT EXISTS username VARCHAR(64);
ALTER TABLE outgoingwebhooks ADD COLUMN IF NOT EXISTS iconurl VARCHAR(1024);
ALTER TABLE outgoingwebhooks ADD COLUMN IF NOT EXISTS description VARCHAR(500);

CREATE INDEX IF NOT EXISTS idx_outgoing_webhook_team_id ON outgoingwebhooks (teamid);
CREATE INDEX IF NOT EXISTS idx_outgoing_webhook_update_at ON outgoingwebhooks (updateat);
CREATE INDEX IF NOT EXISTS idx_outgoing_webhook_create_at ON outgoingwebhooks (createat);
CREATE INDEX IF NOT EXISTS idx_outgoing_webhook_delete_at ON outgoingwebhooks (deleteat);

DO $$
DECLARE 
    column_exist boolean := false;
BEGIN
SELECT count(*) != 0 INTO column_exist
    FROM information_schema.columns
    WHERE table_name = 'outgoingwebhooks'
    AND table_schema = current_schema()
    AND column_name = 'description'
    AND NOT data_type = 'VARCHAR(500)';
IF column_exist THEN
    ALTER TABLE outgoingwebhooks ALTER COLUMN description TYPE VARCHAR(500);
END IF;
END $$;

DO $$
DECLARE 
    column_exist boolean := false;
BEGIN
SELECT count(*) != 0 INTO column_exist
    FROM information_schema.columns
    WHERE table_name = 'outgoingwebhooks'
    AND table_schema = current_schema()
    AND column_name = 'iconurl'
    AND NOT data_type = 'VARCHAR(1024)';
IF column_exist THEN
    ALTER TABLE outgoingwebhooks ALTER COLUMN iconurl TYPE VARCHAR(1024);
END IF;
END $$;

DO $$
BEGIN
    IF (
        SELECT column_default::bigint
        FROM information_schema.columns
        WHERE table_schema=current_schema()
        AND table_name='outgoingwebhooks'
        AND column_name='username'
    ) = 0 THEN
        ALTER TABLE outgoingwebhooks ALTER COLUMN username SET DEFAULT NULL;
    END IF;
END $$;

DO $$
BEGIN
    IF (
        SELECT column_default::bigint
        FROM information_schema.columns
        WHERE table_schema=current_schema()
        AND table_name='outgoingwebhooks'
        AND column_name='iconurl'
    ) = 0 THEN
        ALTER TABLE outgoingwebhooks ALTER COLUMN iconurl SET DEFAULT NULL;
    END IF;
END $$;

-- server/channels/db/migrations/postgres/000015_create_systems.up.sql
CREATE TABLE IF NOT EXISTS systems (
    name VARCHAR(64),
    value VARCHAR(1024),
    PRIMARY KEY (name)
);

-- server/channels/db/migrations/postgres/000016_create_reactions.up.sql
CREATE TABLE IF NOT EXISTS reactions(
    userid VARCHAR(26) NOT NULL,
    postid VARCHAR(26) NOT NULL,
    emojiname VARCHAR(64) NOT NULL,
    createat bigint
);

ALTER TABLE reactions ADD COLUMN IF NOT EXISTS updateat bigint;
ALTER TABLE reactions ADD COLUMN IF NOT EXISTS deleteat bigint;

DO $$
<<alter_pk>>
DECLARE
    existing_index text;
BEGIN
    SELECT string_agg(a.attname, ',') INTO existing_index
    FROM pg_constraint AS c
    CROSS JOIN
        (SELECT unnest(conkey) FROM pg_constraint WHERE conrelid = 'reactions'::regclass AND contype='p') AS cols(colnum)
    INNER JOIN pg_attribute AS a ON a.attrelid = c.conrelid AND cols.colnum = a.attnum
    WHERE c.contype = 'p'
    AND c.conrelid = 'reactions'::regclass;

    IF COALESCE (existing_index, '') <> text('postid,userid,emojiname') THEN
        ALTER TABLE reactions
            DROP CONSTRAINT IF EXISTS reactions_pkey,
            ADD PRIMARY KEY (postid, userid, emojiname);
    END IF;
END alter_pk $$;

ALTER TABLE reactions ADD COLUMN IF NOT EXISTS remoteid VARCHAR(26);

-- server/channels/db/migrations/postgres/000017_create_roles.up.sql
CREATE TABLE IF NOT EXISTS roles (
    id VARCHAR(26) PRIMARY KEY,
    name VARCHAR(64),
    displayname VARCHAR(128),
    description VARCHAR(1024),
    createat bigint,
    updateat bigint,
    deleteat bigint,
    permissions VARCHAR(4096),
    schememanaged boolean,
    UNIQUE(name)
);

ALTER TABLE roles ADD COLUMN IF NOT EXISTS builtin boolean;

DO $$
	<< migrate_if_version_below_500 >>
DECLARE
	current_db_version VARCHAR(100) := '';
BEGIN
	SELECT
		value INTO current_db_version
	FROM
		systems
	WHERE
		name = 'Version';
	IF (string_to_array(current_db_version, '.') < string_to_array('5.0.0', '.')) THEN
		 UPDATE Roles SET SchemeManaged = false
            WHERE Name NOT IN ('system_user', 'system_admin', 'team_user', 'team_admin', 'channel_user', 'channel_admin');
	END IF;
END migrate_if_version_below_500
$$;

ALTER TABLE roles ALTER COLUMN permissions TYPE TEXT;

-- server/channels/db/migrations/postgres/000018_create_schemes.up.sql
CREATE TABLE IF NOT EXISTS schemes (
    id VARCHAR(26) PRIMARY KEY,
    name VARCHAR(64),
    displayname VARCHAR(128),
    description VARCHAR(1024),
    createat bigint,
    updateat bigint,
    deleteat bigint,
    scope VARCHAR(32),
    defaultteamadminrole VARCHAR(64),
    defaultteamuserrole VARCHAR(64),
    defaultchanneladminrole VARCHAR(64),
    defaultchanneluserrole VARCHAR(64),
    UNIQUE(name)
);

ALTER TABLE schemes ADD COLUMN IF NOT EXISTS defaultteamguestrole VARCHAR(64);
ALTER TABLE schemes ADD COLUMN IF NOT EXISTS defaultchannelguestrole VARCHAR(64);

ALTER TABLE schemes ALTER COLUMN defaultteamguestrole TYPE VARCHAR(64);
ALTER TABLE schemes ALTER COLUMN defaultchannelguestrole TYPE VARCHAR(64);

CREATE INDEX IF NOT EXISTS idx_schemes_channel_guest_role ON schemes (defaultchannelguestrole);
CREATE INDEX IF NOT EXISTS idx_schemes_channel_user_role ON schemes (defaultchanneluserrole);
CREATE INDEX IF NOT EXISTS idx_schemes_channel_admin_role ON schemes (defaultchanneladminrole);

-- server/channels/db/migrations/postgres/000019_create_licenses.up.sql
CREATE TABLE IF NOT EXISTS licenses (
    id VARCHAR(26) NOT NULL,
    createat bigint,
    bytes VARCHAR(10000),
    PRIMARY KEY (id)
);

-- server/channels/db/migrations/postgres/000020_create_posts.up.sql
CREATE TABLE IF NOT EXISTS posts (
    id VARCHAR(26) PRIMARY KEY,
    createat bigint,
    updateat bigint,
    deleteat bigint,
    userid VARCHAR(26),
    channelid VARCHAR(26),
    rootid VARCHAR(26),
    parentid VARCHAR(26),
    originalid VARCHAR(26),
    message VARCHAR(65535),
    type VARCHAR(26),
    props VARCHAR(8000),
    hashtags VARCHAR(1000),
    filenames VARCHAR(4000)
);

ALTER TABLE posts ADD COLUMN IF NOT EXISTS fileids VARCHAR(300);
ALTER TABLE posts ADD COLUMN IF NOT EXISTS hasreactions boolean;
ALTER TABLE posts ADD COLUMN IF NOT EXISTS editat bigint;
ALTER TABLE posts ADD COLUMN IF NOT EXISTS ispinned boolean;

CREATE INDEX IF NOT EXISTS idx_posts_update_at ON posts(updateat);
CREATE INDEX IF NOT EXISTS idx_posts_create_at ON posts(createat);
CREATE INDEX IF NOT EXISTS idx_posts_delete_at ON posts(deleteat);
CREATE INDEX IF NOT EXISTS idx_posts_root_id ON posts(rootid);
CREATE INDEX IF NOT EXISTS idx_posts_user_id ON posts(userid);
CREATE INDEX IF NOT EXISTS idx_posts_is_pinned ON posts(ispinned);
CREATE INDEX IF NOT EXISTS idx_posts_channel_id_update_at ON posts(channelid, updateat);
CREATE INDEX IF NOT EXISTS idx_posts_channel_id_delete_at_create_at ON posts(channelid, deleteat, createat);
CREATE INDEX IF NOT EXISTS idx_posts_message_txt ON posts USING gin(to_tsvector('english', message));
CREATE INDEX IF NOT EXISTS idx_posts_hashtags_txt ON posts USING gin(to_tsvector('english', hashtags));

ALTER TABLE posts ADD COLUMN IF NOT EXISTS remoteid VARCHAR(26);

DROP INDEX IF EXISTS idx_posts_channel_id;

DO $$
DECLARE 
    column_exist boolean := false;
BEGIN
SELECT count(*) != 0 INTO column_exist
    FROM information_schema.columns
    WHERE table_name = 'posts'
    AND table_schema = current_schema()
    AND column_name = 'fileids'
    AND NOT data_type = 'varchar(300)';
IF column_exist THEN
    ALTER TABLE posts ALTER COLUMN fileids TYPE varchar(300);
END IF;
END $$;

-- server/channels/db/migrations/postgres/000021_create_product_notice_view_state.up.sql
CREATE TABLE IF NOT EXISTS productnoticeviewstate (
    userid VARCHAR(26),
    noticeid VARCHAR(26),
    viewed integer,
    "timestamp" bigint,
    PRIMARY KEY (userid, noticeid)
);

CREATE INDEX IF NOT EXISTS idx_notice_views_notice_id ON productnoticeviewstate(noticeid);
CREATE INDEX IF NOT EXISTS idx_notice_views_timestamp ON productnoticeviewstate("timestamp");

DROP INDEX IF EXISTS idx_notice_views_user_id;
DROP INDEX IF EXISTS idx_notice_views_user_notice;

-- server/channels/db/migrations/postgres/000022_create_sessions.up.sql
CREATE TABLE IF NOT EXISTS sessions (
    id VARCHAR(26) PRIMARY KEY,
    token VARCHAR(26),
    createat bigint,
    expiresat bigint,
    lastactivityat bigint,
    userid VARCHAR(26),
    deviceid VARCHAR(512),
    roles VARCHAR(64),
    isoauth boolean,
    props VARCHAR(1000)
);

ALTER TABLE sessions ADD COLUMN IF NOT EXISTS expirednotify boolean;

CREATE INDEX IF NOT EXISTS idx_sessions_user_id ON sessions (userid);
CREATE INDEX IF NOT EXISTS idx_sessions_token ON sessions (token);
CREATE INDEX IF NOT EXISTS idx_sessions_expires_at ON sessions (expiresat);
CREATE INDEX IF NOT EXISTS idx_sessions_create_at ON sessions (createat);
CREATE INDEX IF NOT EXISTS idx_sessions_last_activity_at ON sessions (lastactivityat);

DO $$
	<< migrate_if_version_below_5120 >>
DECLARE
	current_db_version VARCHAR(100) := '';
BEGIN
	SELECT
		value INTO current_db_version
	FROM
		systems
	WHERE
		name = 'Version';
	IF (string_to_array(current_db_version, '.') < string_to_array('5.12.0', '.')) THEN	
        DELETE FROM sessions where expiresat > 3000000000000;
	END IF;
END migrate_if_version_below_5120
$$;

-- server/channels/db/migrations/postgres/000023_create_terms_of_service.up.sql
CREATE TABLE IF NOT EXISTS termsofservice (
    id VARCHAR(26) PRIMARY KEY,
    createat bigint,
    userid VARCHAR(26),
    text VARCHAR(65535)
);

-- server/channels/db/migrations/postgres/000024_create_audits.up.sql
CREATE TABLE IF NOT EXISTS audits (
    id VARCHAR(26) PRIMARY KEY,
    createat bigint,
    userid VARCHAR(26),
    action VARCHAR(512),
    extrainfo VARCHAR(1024),
    ipaddress VARCHAR(64),
    sessionid VARCHAR(26)
);

CREATE INDEX IF NOT EXISTS idx_audits_user_id ON audits (userid);

-- server/channels/db/migrations/postgres/000025_create_oauth_access_data.up.sql
CREATE TABLE IF NOT EXISTS oauthaccessdata (
    token VARCHAR(26) NOT NULL,
    refreshtoken VARCHAR(26),
    redirecturi VARCHAR(256),
    PRIMARY KEY (token)
);

CREATE INDEX IF NOT EXISTS idx_oauthaccessdata_refresh_token ON oauthaccessdata (refreshtoken);

ALTER TABLE oauthaccessdata ADD COLUMN IF NOT EXISTS clientid VARCHAR(26);

ALTER TABLE oauthaccessdata ADD COLUMN IF NOT EXISTS userid VARCHAR(26);
CREATE INDEX IF NOT EXISTS idx_oauthaccessdata_user_id ON oauthaccessdata (userid);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT conname
        FROM pg_constraint
        WHERE conname = 'oauthaccessdata_clientid_userid_key'
    )
    THEN
        ALTER TABLE oauthaccessdata ADD CONSTRAINT oauthaccessdata_clientid_userid_key UNIQUE (clientid, userid);
    END IF;
END $$;

ALTER TABLE oauthaccessdata ADD COLUMN IF NOT EXISTS expiresat bigint;

DROP INDEX IF EXISTS idx_oauthaccessdata_auth_code;
ALTER TABLE oauthaccessdata DROP COLUMN IF EXISTS authcode;

ALTER TABLE oauthaccessdata ADD COLUMN IF NOT EXISTS scope VARCHAR(128);

DROP INDEX IF EXISTS clientid_2;

DROP INDEX IF EXISTS idx_oauthaccessdata_client_id;

-- server/channels/db/migrations/postgres/000026_create_preferences.up.sql
CREATE TABLE IF NOT EXISTS preferences (
    userid varchar(26) NOT NULL,
    category varchar(32) NOT NULL,
    name varchar(32) NOT NULL,
    value varchar(2000),
    PRIMARY KEY (userid, category, name)
);

CREATE INDEX IF NOT EXISTS idx_preferences_category ON preferences(category);
CREATE INDEX IF NOT EXISTS idx_preferences_name ON preferences(name);

DO $$
<<modify_column_type_if_type_is_different>>
DECLARE
    type_exists boolean := false;
    col_exists boolean := false;
BEGIN
    SELECT count(*) != 0 INTO col_exists
    FROM information_schema.columns
    WHERE table_name = 'preferences'
    AND table_schema = current_schema()
    AND column_name = 'value';

    SELECT count(*) != 0 INTO type_exists
    FROM information_schema.columns
    WHERE table_name = 'preferences'
    AND table_schema = current_schema()
    AND column_name = 'value'
    AND data_type = 'character varying'
    AND character_maximum_length = 2000;

    IF col_exists AND NOT type_exists THEN
        ALTER TABLE preferences ALTER COLUMN value TYPE varchar(2000);
    END IF;
END modify_column_type_if_type_is_different $$;

DO $$
<<rename_solarized_theme>>
DECLARE
    preference record;
BEGIN
    FOR preference IN
        SELECT * FROM preferences WHERE category = 'theme' AND value LIKE '%solarized_%'
    LOOP
        UPDATE preferences
            SET value = replace(preference.value, 'solarized_', 'solarized-')
        WHERE userid = preference.userid
        AND category = preference.category
        AND name = preference.name;
    END LOOP;
END rename_solarized_theme $$;

DROP INDEX IF EXISTS idx_preferences_user_id;

-- server/channels/db/migrations/postgres/000027_create_status.up.sql
CREATE TABLE IF NOT EXISTS status (
    userid VARCHAR(26) PRIMARY KEY,
    status VARCHAR(32),
    manual boolean,
    lastactivityat bigint
);

ALTER TABLE status DROP COLUMN IF EXISTS activechannel;

CREATE INDEX IF NOT EXISTS idx_status_status ON status(status);

ALTER TABLE status ADD COLUMN IF NOT EXISTS dndendtime bigint;
ALTER TABLE status ADD COLUMN IF NOT EXISTS prevstatus VARCHAR(32);

DROP INDEX IF EXISTS idx_status_user_id;

-- server/channels/db/migrations/postgres/000028_create_tokens.up.sql
CREATE TABLE IF NOT EXISTS tokens (
    token VARCHAR(64) PRIMARY KEY,
    createat bigint,
    type VARCHAR(64),
    extra VARCHAR(2048)
);

ALTER TABLE tokens ALTER COLUMN extra TYPE VARCHAR(2048);

DO $$
<<modify_column_type_if_type_is_different>>
DECLARE
    type_exists boolean := false;
    col_exists boolean := false;
BEGIN
    SELECT count(*) != 0 INTO col_exists
    FROM information_schema.columns
    WHERE table_name = 'tokens'
    AND table_schema = current_schema()
    AND column_name = 'extra';

    SELECT count(*) != 0 INTO type_exists
    FROM information_schema.columns
    WHERE table_name = 'tokens'
    AND table_schema = current_schema()
    AND column_name = 'extra'
    AND data_type = 'character varying'
    AND character_maximum_length = 2048;

    IF col_exists AND NOT type_exists THEN
        ALTER TABLE tokens ALTER COLUMN extra TYPE VARCHAR(2048);
    END IF;
END modify_column_type_if_type_is_different $$;

-- server/channels/db/migrations/postgres/000029_create_bots.up.sql
CREATE TABLE IF NOT EXISTS bots (
    userid VARCHAR(26) PRIMARY KEY,
    description VARCHAR(1024),
    ownerid VARCHAR(190),
    createat bigint,
    updateat bigint,
    deleteat bigint
);

ALTER TABLE bots ADD COLUMN IF NOT EXISTS lasticonupdate bigint;

-- server/channels/db/migrations/postgres/000030_create_user_access_tokens.up.sql
CREATE TABLE IF NOT EXISTS useraccesstokens (
    id VARCHAR(26) PRIMARY KEY,
    token VARCHAR(26) UNIQUE,
    userid VARCHAR(26),
    description VARCHAR(512)
);

ALTER TABLE useraccesstokens ADD COLUMN IF NOT EXISTS isactive boolean;
CREATE INDEX IF NOT EXISTS idx_user_access_tokens_user_id ON useraccesstokens(userid);

DROP INDEX IF EXISTS idx_user_access_tokens_token;

-- server/channels/db/migrations/postgres/000031_create_remote_clusters.up.sql
CREATE TABLE IF NOT EXISTS remoteclusters (
    remoteid VARCHAR(26) NOT NULL,
    remoteteamid VARCHAR(26),
    name VARCHAR(64) NOT NULL,
    displayname VARCHAR(64),
    siteurl VARCHAR(512),
    createat bigint,
    lastpingat bigint,
    token VARCHAR(26),
    remotetoken VARCHAR(26),
    topics VARCHAR(512),
    creatorid VARCHAR(26),
    PRIMARY KEY (remoteid, name)
);

CREATE UNIQUE INDEX IF NOT EXISTS remote_clusters_site_url_unique ON remoteclusters (siteurl, remoteteamid);

-- server/channels/db/migrations/postgres/000032_create_sharedchannels.up.sql
CREATE TABLE IF NOT EXISTS sharedchannels (
    channelid character varying(26) NOT NULL,
    teamid character varying(26),
    home boolean,
    readonly boolean,
    sharename character varying(64),
    sharedisplayname character varying(64),
    sharepurpose character varying(250),
    shareheader character varying(1024),
    creatorid character varying(26),
    createat bigint,
    updateat bigint,
    remoteid character varying(26),
    PRIMARY KEY (channelid),
    UNIQUE (sharename, teamid)
);

-- server/channels/db/migrations/postgres/000033_create_sidebar_channels.up.sql
CREATE TABLE IF NOT EXISTS sidebarchannels (
    channelid VARCHAR(26),
    userid VARCHAR(26),
    categoryid VARCHAR(26),
    sortorder bigint,
    PRIMARY KEY (channelid, userid, categoryid)
);

DO $$
<<modify_column_type_if_type_is_different>>
DECLARE
    col_exist_and_type_different boolean := false;
BEGIN
    SELECT count(*) != 0 INTO col_exist_and_type_different
    FROM information_schema.columns
    WHERE table_name = 'sidebarchannels'
    AND table_schema = current_schema()
    AND column_name = 'categoryid'
    AND data_type = 'character varying'
    AND NOT character_maximum_length = 128;

    IF col_exist_and_type_different THEN
        ALTER TABLE sidebarchannels ALTER COLUMN categoryid TYPE varchar(128);
    END IF;
END modify_column_type_if_type_is_different $$

-- server/channels/db/migrations/postgres/000034_create_oauthauthdata.up.sql
CREATE TABLE IF NOT EXISTS oauthauthdata (
    clientid varchar(26),
    userid varchar(26),
    code varchar(128) NOT NULL,
    expiresin integer,
    createat bigint,
    redirecturi varchar(256),
    state varchar(1024),
    scope varchar(128),
    PRIMARY KEY (code)
);

DO $$
<<modify_column_type_if_type_is_different>>
DECLARE
    type_exists boolean := false;
    col_exists boolean := false;
BEGIN
    SELECT count(*) != 0 INTO col_exists
    FROM information_schema.columns
    WHERE table_name = 'oauthauthdata'
    AND table_schema = current_schema()
    AND column_name = 'state';

    SELECT count(*) != 0 INTO type_exists
    FROM information_schema.columns
    WHERE table_name = 'oauthauthdata'
    AND table_schema = current_schema()
    AND column_name = 'state'
    AND data_type = 'character varying'
    AND character_maximum_length = 1024;

    IF col_exists AND NOT type_exists THEN
        ALTER TABLE oauthauthdata ALTER COLUMN state TYPE varchar(1024);
    END IF;
END modify_column_type_if_type_is_different $$;

DROP INDEX IF EXISTS idx_oauthauthdata_client_id;

-- server/channels/db/migrations/postgres/000035_create_sharedchannelattachments.up.sql
CREATE TABLE IF NOT EXISTS sharedchannelattachments (
    id varchar(26) NOT NULL,
    fileid varchar(26),
    remoteid varchar(26),
    createat bigint,
    lastsyncat bigint,
    PRIMARY KEY (id),
    UNIQUE (fileid, remoteid)
);

-- server/channels/db/migrations/postgres/000036_create_sharedchannelusers.up.sql
CREATE TABLE IF NOT EXISTS sharedchannelusers (
    id varchar(26) NOT NULL,
    userid varchar(26),
    remoteid varchar(26),
    createat bigint,
    lastsyncat bigint,
    PRIMARY KEY (id)
);

ALTER TABLE sharedchannelusers ADD COLUMN IF NOT EXISTS channelid varchar(26);

DO $$
BEGIN
    IF NOT EXISTS (
       SELECT conname
       FROM pg_constraint
       WHERE conname = 'sharedchannelusers_userid_channelid_remoteid_key'
    )
    THEN
        ALTER TABLE sharedchannelusers ADD CONSTRAINT sharedchannelusers_userid_channelid_remoteid_key UNIQUE (userid, channelid, remoteid);
    END IF;
END $$;

DROP INDEX IF EXISTS idx_sharedchannelusers_user_id;

CREATE INDEX IF NOT EXISTS idx_sharedchannelusers_remote_id ON sharedchannelusers(remoteid);

-- server/channels/db/migrations/postgres/000037_create_sharedchannelremotes.up.sql
CREATE TABLE IF NOT EXISTS sharedchannelremotes (
    id character varying(26) NOT NULL,
    channelid character varying(26) NOT NULL,
    creatorid character varying(26),
    createat bigint,
    updateat bigint,
    isinviteaccepted boolean,
    isinviteconfirmed boolean,
    remoteid character varying(26),
    PRIMARY KEY(id, channelid),
    UNIQUE(channelid, remoteid)
);

ALTER TABLE sharedchannelremotes ADD COLUMN IF NOT EXISTS LastPostUpdateAt bigint;
ALTER TABLE sharedchannelremotes ADD COLUMN IF NOT EXISTS LastPostId character varying(26);
-- server/channels/db/migrations/postgres/000038_create_jobs.up.sql
CREATE TABLE IF NOT EXISTS jobs (
    id VARCHAR(26) PRIMARY KEY,
    type VARCHAR(32),
    priority bigint,
    createat bigint,
    startat bigint,
    lastactivityat bigint,
    status VARCHAR(32),
    progress bigint,
    data VARCHAR(1024)
);

CREATE INDEX IF NOT EXISTS idx_jobs_type ON jobs (type);

-- server/channels/db/migrations/postgres/000039_create_channel_member_history.up.sql
CREATE TABLE IF NOT EXISTS channelmemberhistory (
    channelid VARCHAR(26) NOT NULL,
    userid VARCHAR(26) NOT NULL,
    jointime bigint NOT NULL,
    leavetime bigint,
    PRIMARY KEY (channelid, userid, jointime)
);

ALTER TABLE channelmemberhistory DROP COLUMN IF EXISTS email;
ALTER TABLE channelmemberhistory DROP COLUMN IF EXISTS username;

-- server/channels/db/migrations/postgres/000040_create_sidebar_categories.up.sql
CREATE TABLE IF NOT EXISTS sidebarcategories (
    id VARCHAR(26),
    userid VARCHAR(26),
    teamid VARCHAR(26),
    sortorder bigint,
    sorting VARCHAR(64),
    type VARCHAR(64),
    displayname VARCHAR(64),
    PRIMARY KEY (id)
);

DO $$
<<modify_column_type_if_type_is_different>>
DECLARE
    col_exist_and_type_different boolean := false;
BEGIN
    SELECT count(*) != 0 INTO col_exist_and_type_different
    FROM information_schema.columns
    WHERE table_name = 'sidebarcategories'
    AND table_schema = current_schema()
    AND column_name = 'id'
    AND data_type = 'character varying'
    AND NOT character_maximum_length = 128;

    IF col_exist_and_type_different THEN
        ALTER TABLE sidebarcategories ALTER COLUMN id TYPE varchar(128);
    END IF;
END modify_column_type_if_type_is_different $$;

ALTER TABLE sidebarcategories ADD COLUMN IF NOT EXISTS muted boolean;
ALTER TABLE sidebarcategories ADD COLUMN IF NOT EXISTS collapsed boolean;

-- server/channels/db/migrations/postgres/000041_create_upload_sessions.up.sql
CREATE TABLE IF NOT EXISTS uploadsessions (
    id VARCHAR(26) PRIMARY KEY,
    type VARCHAR(32),
    createat bigint,
    userid VARCHAR(26),
    channelid VARCHAR(26),
    filename VARCHAR(256),
    path VARCHAR(512),
    filesize bigint,
    fileoffset bigint
);

CREATE INDEX IF NOT EXISTS idx_uploadsessions_user_id ON uploadsessions(userid);
CREATE INDEX IF NOT EXISTS idx_uploadsessions_create_at ON uploadsessions(createat);
CREATE INDEX IF NOT EXISTS idx_uploadsessions_type ON uploadsessions(type);

ALTER TABLE uploadsessions ADD COLUMN IF NOT EXISTS remoteid VARCHAR(26);
ALTER TABLE uploadsessions ADD COLUMN IF NOT EXISTS reqfileid VARCHAR(26);

DO $$
	<< migrate_if_version_below_5350 >>
DECLARE
	current_db_version VARCHAR(100) := '';
BEGIN
	SELECT
		value INTO current_db_version
	FROM
		systems
	WHERE
		name = 'Version';
	IF (string_to_array(current_db_version, '.') < string_to_array('5.35.0', '.')) THEN
		UPDATE UploadSessions SET RemoteId='', ReqFileId='' WHERE RemoteId IS NULL;
	END IF;
END migrate_if_version_below_5350
$$;

-- server/channels/db/migrations/postgres/000042_create_threads.up.sql
CREATE TABLE IF NOT EXISTS threads (
    postid VARCHAR(26) PRIMARY KEY,
    replycount bigint,
    lastreplyat bigint,
    participants text
);

ALTER TABLE threads ADD COLUMN IF NOT EXISTS channelid VARCHAR(26);

CREATE INDEX IF NOT EXISTS idx_threads_channel_id ON threads (channelid);

DO $$
	<< migrate_empty_threads >>
DECLARE
	empty_threads_exist boolean := FALSE;
BEGIN
	SELECT
		count(*) != 0 INTO empty_threads_exist
	FROM
		threads
	WHERE
		channelid IS NULL;
	IF empty_threads_exist THEN
		UPDATE
			threads
		SET
			channelId = posts.channelid
		FROM
			posts
		WHERE
			posts.id = threads.postid
			AND threads.channelid IS NULL;
	END IF;
END migrate_empty_threads
$$;

-- server/channels/db/migrations/postgres/000043_thread_memberships.up.sql
CREATE TABLE IF NOT EXISTS threadmemberships(
    postid VARCHAR(26) NOT NULL,
    userid VARCHAR(26) NOT NULL,
    following boolean,
    lastviewed bigint,
    lastupdated bigint,
    PRIMARY KEY (postid, userid)
);

ALTER TABLE threadmemberships ADD COLUMN IF NOT EXISTS unreadmentions bigint;

CREATE INDEX IF NOT EXISTS idx_thread_memberships_last_update_at ON threadmemberships(lastupdated);
CREATE INDEX IF NOT EXISTS idx_thread_memberships_last_view_at ON threadmemberships(lastviewed);
CREATE INDEX IF NOT EXISTS idx_thread_memberships_user_id ON threadmemberships(userid);

-- server/channels/db/migrations/postgres/000044_create_user_terms_of_service.up.sql
-- This migration depends on users table
CREATE TABLE IF NOT EXISTS usertermsofservice (
    userid VARCHAR(26) PRIMARY KEY,
    termsofserviceid VARCHAR(26),
    createat bigint
);

DO $$
<<do_migrate_to_usertermsofservice_table>>
DECLARE
    col_exist boolean := false;
BEGIN
    SELECT count(*) != 0 INTO col_exist
    FROM information_schema.columns
    WHERE table_name = 'users'
    AND column_name = 'acceptedtermsofserviceid';

    IF col_exist THEN
    INSERT INTO usertermsofservice
        SELECT id, acceptedtermsofserviceid as termsofserviceid, (extract(epoch from now()) * 1000)
        FROM users
        WHERE acceptedtermsofserviceid != ''
        AND acceptedtermsofserviceid IS NOT NULL;
    END IF;
END do_migrate_to_usertermsofservice_table $$;

DROP INDEX IF EXISTS idx_user_terms_of_service_user_id;

-- server/channels/db/migrations/postgres/000045_create_plugin_key_value_store.up.sql
CREATE TABLE IF NOT EXISTS pluginkeyvaluestore (
    pluginid VARCHAR(190) NOT NULL,
    pkey VARCHAR(50) NOT NULL,
    pvalue bytea,
    PRIMARY KEY (pluginid, pkey)
);

ALTER TABLE pluginkeyvaluestore ADD COLUMN IF NOT EXISTS expireat bigint DEFAULT 0;

DO $$BEGIN
    IF (
        SELECT column_default::bigint
        FROM information_schema.columns
        WHERE table_schema=current_schema()
        AND table_name='pluginkeyvaluestore'
        AND column_name='expireat'
    ) = 0 THEN
        ALTER TABLE pluginkeyvaluestore ALTER COLUMN expireat SET DEFAULT NULL;
    END IF;
END$$;

-- server/channels/db/migrations/postgres/000046_create_users.up.sql
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(26) PRIMARY KEY,
    createat bigint,
    updateat bigint,
    deleteat bigint,
    username VARCHAR(64) UNIQUE,
    password VARCHAR(128),
    authdata VARCHAR(128) UNIQUE,
    authservice VARCHAR(32),
    email VARCHAR(128) UNIQUE,
    emailverified boolean,
    nickname VARCHAR(64),
    firstname VARCHAR(64),
    lastname VARCHAR(64),
    roles VARCHAR(256),
    allowmarketing boolean,
    props VARCHAR(4000),
    notifyprops VARCHAR(2000),
    lastpasswordupdate bigint,
    lastpictureupdate bigint,
    failedattempts integer,
    locale VARCHAR(5),
    mfaactive boolean,
    mfasecret VARCHAR(128)
);

ALTER TABLE users DROP COLUMN IF EXISTS lastactivityat;
ALTER TABLE users DROP COLUMN IF EXISTS lastpingat;
ALTER TABLE users ADD COLUMN IF NOT EXISTS position VARCHAR(128);
ALTER TABLE users ADD COLUMN IF NOT EXISTS timezone VARCHAR(256) DEFAULT '{"automaticTimezone":"","manualTimezone":"","useAutomaticTimezone":"true"}';
ALTER TABLE users ALTER COLUMN position TYPE VARCHAR(128);

DO $$
	<< migrate_if_version_below_4100 >>
DECLARE
	current_db_version VARCHAR(100) := '';
BEGIN
	SELECT
		value INTO current_db_version
	FROM
		systems
	WHERE
		name = 'Version';
	IF (string_to_array(current_db_version, '.') < string_to_array('4.10.0', '.')) THEN	
        UPDATE Users SET AuthData=LOWER(AuthData) WHERE AuthService = 'saml';
	END IF;
END migrate_if_version_below_4100
$$;

DO $$
DECLARE 
    column_exist boolean := false;
BEGIN
SELECT count(*) != 0 INTO column_exist
    FROM information_schema.columns
    WHERE table_name = 'users'
    AND table_schema = current_schema()
    AND column_name = 'roles'
    AND NOT data_type = 'varchar(256)';
IF column_exist THEN
    ALTER TABLE users ALTER COLUMN roles TYPE varchar(256);
END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_users_update_at ON users (updateat);
CREATE INDEX IF NOT EXISTS idx_users_create_at ON users (createat);
CREATE INDEX IF NOT EXISTS idx_users_delete_at ON users (deleteat);

CREATE INDEX IF NOT EXISTS idx_users_email_lower_textpattern ON users (lower(email) text_pattern_ops);
CREATE INDEX IF NOT EXISTS idx_users_username_lower_textpattern ON users (lower(username) text_pattern_ops);
CREATE INDEX IF NOT EXISTS idx_users_nickname_lower_textpattern ON users (lower(nickname) text_pattern_ops);
CREATE INDEX IF NOT EXISTS idx_users_firstname_lower_textpattern ON users (lower(firstname) text_pattern_ops);
CREATE INDEX IF NOT EXISTS idx_users_lastname_lower_textpattern ON users (lower(lastname) text_pattern_ops);

CREATE INDEX IF NOT EXISTS idx_users_all_txt ON users USING gin(to_tsvector('english', username || ' ' || firstname || ' ' || lastname || ' ' || nickname || ' ' || email));
CREATE INDEX IF NOT EXISTS idx_users_all_no_full_name_txt ON users USING gin(to_tsvector('english', username || ' ' || nickname || ' ' || email));
CREATE INDEX IF NOT EXISTS idx_users_names_txt ON users USING gin(to_tsvector('english', username || ' ' || firstname || ' ' || lastname || ' ' || nickname));
CREATE INDEX IF NOT EXISTS idx_users_names_no_full_name_txt ON users USING gin(to_tsvector('english', username || ' ' || nickname));

DROP INDEX IF EXISTS idx_users_email_lower;
DROP INDEX IF EXISTS idx_users_username_lower;
DROP INDEX IF EXISTS idx_users_nickname_lower;
DROP INDEX IF EXISTS idx_users_firstname_lower;
DROP INDEX IF EXISTS idx_users_lastname_lower;

ALTER TABLE users ADD COLUMN IF NOT EXISTS remoteid VARCHAR(26);

DROP INDEX IF EXISTS idx_users_email;

-- server/channels/db/migrations/postgres/000047_create_file_info.up.sql
CREATE TABLE IF NOT EXISTS fileinfo (
    id VARCHAR(26) PRIMARY KEY,
    creatorid VARCHAR(26),
    postid VARCHAR(26),
    createat bigint,
    updateat bigint,
    deleteat bigint,
    path VARCHAR(512),
    thumbnailpath VARCHAR(512),
    previewpath VARCHAR(512),
    name VARCHAR(256),
    extension VARCHAR(64),
    size bigint,
    mimetype VARCHAR(256),
    width integer,
    height integer,
    haspreviewimage boolean
);

CREATE INDEX IF NOT EXISTS idx_fileinfo_update_at ON fileinfo (updateat);
CREATE INDEX IF NOT EXISTS idx_fileinfo_create_at ON fileinfo (createat);
CREATE INDEX IF NOT EXISTS idx_fileinfo_delete_at ON fileinfo (deleteat);
CREATE INDEX IF NOT EXISTS idx_fileinfo_postid_at ON fileinfo (postid);
CREATE INDEX IF NOT EXISTS idx_fileinfo_extension_at ON fileinfo (extension);
CREATE INDEX IF NOT EXISTS idx_fileinfo_name_txt ON fileinfo USING gin(to_tsvector('english', name));

ALTER TABLE fileinfo ADD COLUMN IF NOT EXISTS minipreview bytea;
ALTER TABLE fileinfo ADD COLUMN IF NOT EXISTS content text;

CREATE INDEX IF NOT EXISTS idx_fileinfo_content_txt ON fileinfo USING gin(to_tsvector('english', content));
CREATE INDEX IF NOT EXISTS idx_fileinfo_name_splitted ON fileinfo USING gin (to_tsvector('english'::regconfig, translate((name)::text, '.,-'::text, '   '::text)));

ALTER TABLE fileinfo ADD COLUMN IF NOT EXISTS remoteid varchar(26);

-- server/channels/db/migrations/postgres/000048_create_oauth_apps.up.sql
CREATE TABLE IF NOT EXISTS oauthapps (
    id VARCHAR(26) PRIMARY KEY,
    creatorid VARCHAR(26),
    createat bigint,
    updateat bigint,
    clientsecret VARCHAR(128),
    name VARCHAR(64),
    description VARCHAR(512),
    callbackurls VARCHAR(1024),
    homepage VARCHAR(256)
);

CREATE INDEX IF NOT EXISTS idx_oauthapps_creator_id ON oauthapps (creatorid);

ALTER TABLE oauthapps ADD COLUMN IF NOT EXISTS istrusted boolean;
ALTER TABLE oauthapps ADD COLUMN IF NOT EXISTS iconurl VARCHAR(512);

-- server/channels/db/migrations/postgres/000049_create_channels.up.sql
CREATE TABLE IF NOT EXISTS channels (
    id varchar(26) PRIMARY KEY,
    createat bigint,
    updateat bigint,
    deleteat bigint,
    teamid varchar(26),
    type varchar(1),
    displayname varchar(64),
    name varchar(64),
    header varchar(1024),
    purpose varchar(128),
    lastpostat bigint,
    totalmsgcount bigint,
    extraupdateat bigint,
    creatorid varchar(26),
    UNIQUE(name, teamid)
);

CREATE INDEX IF NOT EXISTS idx_channels_displayname ON channels (displayname);
CREATE INDEX IF NOT EXISTS idx_channels_txt ON channels (name, displayname);
CREATE INDEX IF NOT EXISTS idx_channels_displayname_lower ON channels (lower(displayname));
CREATE INDEX IF NOT EXISTS idx_channels_name_lower ON channels (lower(name));
CREATE INDEX IF NOT EXISTS idx_channels_name ON channels (name);
CREATE INDEX IF NOT EXISTS idx_channels_update_at ON channels (updateat);
CREATE INDEX IF NOT EXISTS idx_channels_team_id ON channels (teamid);
CREATE INDEX IF NOT EXISTS idx_channels_delete_at ON channels (deleteat);
CREATE INDEX IF NOT EXISTS idx_channels_create_at ON channels (createat);
CREATE INDEX IF NOT EXISTS idx_channel_search_txt ON channels using gin (to_tsvector('english'::regconfig, (((((name)::text || ' '::text) || (displayname)::text) || ' '::text) || (purpose)::text)));

DO $$
<<modify_column_type_if_type_is_different>>
DECLARE
    col_exist_and_type_different boolean := false;
BEGIN
    SELECT count(*) != 0 INTO col_exist_and_type_different
    FROM information_schema.columns
    WHERE table_name = 'channels'
    AND table_schema = current_schema()
    AND column_name = 'purpose'
    AND data_type = 'character varying'
    AND NOT character_maximum_length = 250;

    IF col_exist_and_type_different THEN
        ALTER TABLE channels ALTER COLUMN purpose TYPE varchar(250);
    END IF;
END modify_column_type_if_type_is_different $$;

DROP INDEX IF EXISTS idx_channels_displayname;

ALTER TABLE channels ADD COLUMN IF NOT EXISTS schemeid varchar(26);

DROP INDEX IF EXISTS idx_channels_txt;

ALTER TABLE channels ADD COLUMN IF NOT EXISTS groupconstrained boolean;

DO $$
<<modify_column_type_if_type_is_different>>
DECLARE
    col_exist_and_type_different boolean := false;
BEGIN
    SELECT count(*) != 0 INTO col_exist_and_type_different
    FROM information_schema.columns
    WHERE table_name = 'channels'
    AND table_schema = current_schema()
    AND column_name = 'groupconstrained'
    AND NOT data_type = 'boolean';

    IF col_exist_and_type_different THEN
        ALTER TABLE channels ALTER COLUMN groupconstrained TYPE boolean;
    END IF;
END modify_column_type_if_type_is_different $$;

CREATE INDEX IF NOT EXISTS idx_channels_scheme_id ON channels (schemeid);

ALTER TABLE channels ADD COLUMN IF NOT EXISTS shared boolean;

DROP INDEX IF EXISTS idx_channels_name;


-- server/channels/db/migrations/postgres/000050_create_channelmembers.up.sql
CREATE TABLE IF NOT EXISTS channelmembers (
    channelid varchar(26) NOT NULL,
    userid varchar(26) NOT NULL,
    roles varchar(64),
    lastviewedat bigint,
    msgcount bigint,
    mentioncount bigint,
    notifyprops varchar(2000),
    lastupdateat bigint,
    PRIMARY KEY (channelid, userid)
);

CREATE INDEX IF NOT EXISTS idx_channelmembers_user_id ON channelmembers(userid);

ALTER TABLE channelmembers ADD COLUMN IF NOT EXISTS schemeuser boolean;
ALTER TABLE channelmembers ADD COLUMN IF NOT EXISTS schemeadmin boolean;

ALTER TABLE channelmembers ADD COLUMN IF NOT EXISTS schemeguest boolean;

DROP INDEX IF EXISTS idx_channelmembers_channel_id;

-- server/channels/db/migrations/postgres/000051_create_msg_root_count.up.sql
DO $$
<<migrate_root_mention_count>>
DECLARE 
    mention_count_root_exist boolean := false;
DECLARE
    msg_count_root_exist boolean := false;
DECLARE
	tmp_count_root integer := 0;
BEGIN
SELECT count(*) != 0 INTO msg_count_root_exist
    FROM information_schema.columns
    WHERE table_name = 'channels'
    AND table_schema = current_schema()
    AND column_name = 'totalmsgcountroot';

 SELECT count(*) != 0 INTO mention_count_root_exist
    FROM information_schema.columns
    WHERE table_name = 'channelmembers'
    AND table_schema = current_schema()
    AND column_name = 'mentioncountroot';

IF mention_count_root_exist THEN
	tmp_count_root := (SELECT count(*) FROM channelmembers WHERE msgcountroot IS NULL OR mentioncountroot IS NULL);
END IF;

ALTER TABLE channelmembers ADD COLUMN IF NOT EXISTS mentioncountroot bigint;

IF (tmp_count_root > 0) THEN
	WITH q AS (
		SELECT ChannelId, COALESCE(SUM(UnreadMentions), 0) AS UnreadMentions, UserId
		FROM ThreadMemberships
		LEFT JOIN Threads ON ThreadMemberships.PostId = Threads.PostId
		GROUP BY Threads.ChannelId, ThreadMemberships.UserId
	)
			UPDATE channelmembers
			SET MentionCountRoot = ChannelMembers.MentionCount - q.UnreadMentions
			FROM q
			WHERE
				q.ChannelId = ChannelMembers.ChannelId AND
				q.UserId = ChannelMembers.UserId AND
				ChannelMembers.MentionCount > 0;
END IF;

ALTER TABLE channels ADD COLUMN IF NOT EXISTS totalmsgcountroot bigint;
ALTER TABLE channels ADD COLUMN IF NOT EXISTS lastrootat bigint;

ALTER TABLE channelmembers ADD COLUMN IF NOT EXISTS msgcountroot bigint;

IF NOT msg_count_root_exist THEN
		WITH q AS (
		SELECT Channels.Id channelid, COALESCE(COUNT(*),0) newcount, COALESCE(MAX(Posts.CreateAt), 0) as lastpost
		FROM Channels
		LEFT JOIN Posts  ON Channels.Id = Posts.ChannelId
		WHERE Posts.RootId = ''
		GROUP BY Channels.Id
	)
		UPDATE Channels SET TotalMsgCountRoot = q.newcount, LastRootAt=q.lastpost
		FROM q where q.channelid=Channels.Id;
END IF;

IF NOT mention_count_root_exist THEN
		WITH q as (SELECT TotalMsgCountRoot, Id, LastRootAt from Channels)
		UPDATE ChannelMembers CM SET MsgCountRoot=TotalMsgCountRoot
		FROM q WHERE q.id=CM.ChannelId AND LastViewedAt >= q.lastrootat;
END IF;

ALTER TABLE channels DROP COLUMN IF EXISTS lastrootat;

END migrate_root_mention_count $$;

-- server/channels/db/migrations/postgres/000052_create_public_channels.up.sql
CREATE TABLE IF NOT EXISTS publicchannels (
	id VARCHAR(26) PRIMARY KEY,
	deleteat bigint,
	teamid VARCHAR(26),
	displayname VARCHAR(64),
	name VARCHAR(64),
	header VARCHAR(1024),
	purpose VARCHAR(250),
	UNIQUE (name, teamid)
);

CREATE INDEX IF NOT EXISTS idx_publicchannels_team_id ON publicchannels (teamid);
CREATE INDEX IF NOT EXISTS idx_publicchannels_name ON publicchannels (name);
CREATE INDEX IF NOT EXISTS idx_publicchannels_delete_at ON publicchannels (deleteat);
CREATE INDEX IF NOT EXISTS idx_publicchannels_name_lower ON publicchannels (lower(name));
CREATE INDEX IF NOT EXISTS idx_publicchannels_displayname_lower ON publicchannels (lower(displayname));
CREATE INDEX IF NOT EXISTS idx_publicchannels_search_txt ON publicchannels using gin (to_tsvector('english'::regconfig, (((((name)::text || ' '::text) || (displayname)::text) || ' '::text) || (purpose)::text)));

DO $$
	<< migratepc >>
BEGIN
	IF(NOT EXISTS (
		SELECT
			1 FROM publicchannels)) THEN
		INSERT INTO publicchannels (id, deleteat, teamid, displayname, name, header, purpose)
		SELECT
			c.id, c.deleteat, c.teamid, c.displayname, c.name, c.header, c.purpose
		FROM
			channels c
		LEFT JOIN publicchannels pc ON (pc.id = c.id)
	WHERE
		c.type = 'O' AND pc.id IS NULL;
	END IF;
END migratepc
$$;

DROP INDEX IF EXISTS idx_publicchannels_name;

-- server/channels/db/migrations/postgres/000053_create_retention_policies.up.sql
CREATE TABLE IF NOT EXISTS retentionpolicies (
	id VARCHAR(26),
	displayname VARCHAR(64),
	postduration bigint,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS retentionpoliciesteams (
	PolicyId varchar(26),
    teamid varchar(26),
    PRIMARY KEY (teamid)
);

CREATE TABLE IF NOT EXISTS retentionpolicieschannels (
	policyid varchar(26),
    channelid varchar(26),
    PRIMARY KEY (channelid)
);

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_retentionpoliciesteams_retentionpolicies') THEN
        ALTER TABLE retentionpoliciesteams
            ADD CONSTRAINT fk_retentionpoliciesteams_retentionpolicies
            FOREIGN KEY (policyid) REFERENCES retentionpolicies (id) ON DELETE CASCADE;
    END IF;
END;
$$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_retentionpolicieschannels_retentionpolicies') THEN
        ALTER TABLE retentionpolicieschannels
            ADD CONSTRAINT fk_retentionpolicieschannels_retentionpolicies
            FOREIGN KEY (policyid) REFERENCES retentionpolicies (id) ON DELETE CASCADE;
    END IF;
END;
$$;

CREATE INDEX IF NOT EXISTS IDX_RetentionPoliciesTeams_PolicyId ON retentionpoliciesteams (policyid);
CREATE INDEX IF NOT EXISTS IDX_RetentionPoliciesChannels_PolicyId ON retentionpolicieschannels (policyid);

DROP INDEX IF EXISTS IDX_RetentionPolicies_DisplayName_Id;
CREATE INDEX IF NOT EXISTS IDX_RetentionPolicies_DisplayName ON retentionpolicies (displayname);

-- server/channels/db/migrations/postgres/000054_create_crt_channelmembership_count.up.sql
/* fixCRTChannelMembershipCounts fixes the channel counts, i.e. the total message count,
total root message count, mention count, and mention count in root messages for users
who have viewed the channel after the last post in the channel */
DO $$
	<< migrate_crt_channelmembership_counts >>
BEGIN
	IF((
		SELECT
			COUNT(*)
		FROM systems
	WHERE
		Name = 'CRTChannelMembershipCountsMigrationComplete') = 0) THEN
		UPDATE
			ChannelMembers
		SET
			MentionCount = 0,
			MentionCountRoot = 0,
			MsgCount = Channels.TotalMsgCount,
			MsgCountRoot = Channels.TotalMsgCountRoot,
			LastUpdateAt = (
				SELECT
					(extract(epoch FROM now()) * 1000)::bigint)
			FROM
				Channels
			WHERE
				ChannelMembers.Channelid = Channels.Id
				AND ChannelMembers.LastViewedAt >= Channels.LastPostAt;
		INSERT INTO Systems
			VALUES('CRTChannelMembershipCountsMigrationComplete', 'true');
	END IF;
END migrate_crt_channelmembership_counts
$$;

-- server/channels/db/migrations/postgres/000055_create_crt_thread_count_and_unreads.up.sql
/* fixCRTThreadCountsAndUnreads Marks threads as read for users where the last
reply time of the thread is earlier than the time the user viewed the channel.
Marking a thread means setting the mention count to zero and setting the
last viewed at time of the the thread as the last viewed at time
of the channel */
DO $$
	<< migrate_crt_thread_counts_and_unreads >>
BEGIN
	IF((
		SELECT
			COUNT(*)
		FROM systems
	WHERE
		Name = 'CRTThreadCountsAndUnreadsMigrationComplete') = 0) THEN
		WITH q AS (
			SELECT
				PostId,
				UserId,
				ChannelMembers.LastViewedAt AS CM_LastViewedAt,
				Threads.LastReplyAt
			FROM
				Threads
				INNER JOIN ChannelMembers ON ChannelMembers.ChannelId = Threads.ChannelId
			WHERE
				Threads.LastReplyAt <= ChannelMembers.LastViewedAt
)
UPDATE
	ThreadMemberships
SET
	LastViewed = q.CM_LastViewedAt + 1,
	UnreadMentions = 0,
	LastUpdated = (
		SELECT
			(extract(epoch FROM now()) * 1000)::bigint)
	FROM
		q
	WHERE
		ThreadMemberships.Postid = q.PostId
		AND ThreadMemberships.UserId = q.UserId;
	INSERT INTO systems
		VALUES('CRTThreadCountsAndUnreadsMigrationComplete', 'true');
END IF;
END migrate_crt_thread_counts_and_unreads
$$;

-- server/channels/db/migrations/postgres/000056_upgrade_channels_v6.0.up.sql
CREATE INDEX IF NOT EXISTS idx_channels_team_id_display_name ON channels(teamid, displayname);
CREATE INDEX IF NOT EXISTS idx_channels_team_id_type ON channels(teamid, type);

DROP INDEX IF EXISTS idx_channels_team_id;

-- server/channels/db/migrations/postgres/000057_upgrade_command_webhooks_v6.0.up.sql
DO $$
<<migrate_root_id_command_webhooks>>
DECLARE 
    parentid_exist boolean := false;
BEGIN
SELECT count(*) != 0 INTO parentid_exist
    FROM information_schema.columns
    WHERE table_name = 'commandwebhooks'
    AND table_schema = current_schema()
    AND column_name = 'parentid';
IF parentid_exist THEN
    UPDATE commandwebhooks SET rootid = parentid WHERE rootid = '' AND rootid != parentid;
END IF;
END migrate_root_id_command_webhooks $$;

ALTER TABLE commandwebhooks DROP COLUMN IF EXISTS parentid;

-- server/channels/db/migrations/postgres/000058_upgrade_channelmembers_v6.0.up.sql
ALTER TABLE channelmembers ALTER COLUMN notifyprops TYPE jsonb USING notifyprops::jsonb;

CREATE INDEX IF NOT EXISTS idx_channelmembers_user_id_channel_id_last_viewed_at ON channelmembers(userid, channelid, lastviewedat);
CREATE INDEX IF NOT EXISTS idx_channelmembers_channel_id_scheme_guest_user_id ON channelmembers(channelid, schemeguest, userid);

DROP INDEX IF EXISTS idx_channelmembers_user_id;

-- server/channels/db/migrations/postgres/000059_upgrade_users_v6.0.up.sql
ALTER TABLE users ALTER COLUMN props TYPE jsonb USING props::jsonb;
ALTER TABLE users ALTER COLUMN notifyprops TYPE jsonb USING notifyprops::jsonb;
ALTER TABLE users ALTER COLUMN timezone DROP DEFAULT;
ALTER TABLE users ALTER COLUMN timezone TYPE jsonb USING timezone::jsonb;

-- server/channels/db/migrations/postgres/000060_upgrade_jobs_v6.0.up.sql
ALTER TABLE jobs ALTER COLUMN data TYPE jsonb USING data::jsonb;

-- server/channels/db/migrations/postgres/000061_upgrade_link_metadata_v6.0.up.sql
ALTER TABLE linkmetadata ALTER COLUMN data TYPE jsonb USING data::jsonb;

-- server/channels/db/migrations/postgres/000062_upgrade_sessions_v6.0.up.sql
ALTER TABLE sessions ALTER COLUMN props TYPE jsonb USING props::jsonb;

-- server/channels/db/migrations/postgres/000063_upgrade_threads_v6.0.up.sql
ALTER TABLE threads ALTER COLUMN participants TYPE jsonb USING participants::jsonb;
CREATE INDEX IF NOT EXISTS idx_threads_channel_id_last_reply_at ON threads(channelid, lastreplyat);
DROP INDEX IF EXISTS idx_threads_channel_id;

-- server/channels/db/migrations/postgres/000064_upgrade_status_v6.0.up.sql
CREATE INDEX IF NOT EXISTS idx_status_status_dndendtime ON status(status, dndendtime);
DROP INDEX IF EXISTS idx_status_status;

-- server/channels/db/migrations/postgres/000065_upgrade_groupchannels_v6.0.up.sql
CREATE INDEX IF NOT EXISTS idx_groupchannels_schemeadmin ON groupchannels(schemeadmin);

-- server/channels/db/migrations/postgres/000066_upgrade_posts_v6.0.up.sql
DO $$
<<migrate_root_id>>
DECLARE 
    parentid_exist boolean := false;
    alter_fileids boolean := false;
    alter_props boolean := false;
BEGIN
SELECT count(*) != 0 INTO parentid_exist
    FROM information_schema.columns
    WHERE table_name = 'posts'
    AND table_schema = current_schema()
    AND column_name = 'parentid';
SELECT count(*) != 0 INTO alter_fileids
    FROM information_schema.columns
    WHERE table_name = 'posts'
    AND table_schema = current_schema()
    AND column_name = 'fileids'
    AND data_type = 'character varying'
    AND character_maximum_length != 300;
SELECT count(*) != 0 INTO alter_props
    FROM information_schema.columns
    WHERE table_name = 'posts'
    AND table_schema = current_schema()
    AND column_name = 'props'
    AND data_type != 'jsonb';
IF alter_fileids OR alter_props THEN
    IF parentid_exist THEN
        UPDATE posts SET rootid = parentid WHERE rootid = '' AND rootid != parentid;
        ALTER TABLE posts ALTER COLUMN fileids TYPE varchar(300), ALTER COLUMN props TYPE jsonb USING props::jsonb, DROP COLUMN ParentId;
    ELSE
        ALTER TABLE posts ALTER COLUMN fileids TYPE varchar(300), ALTER COLUMN props TYPE jsonb USING props::jsonb;
    END IF;
END IF;
END migrate_root_id $$;

CREATE INDEX IF NOT EXISTS idx_posts_root_id_delete_at ON posts(rootid, deleteat);

DROP INDEX IF EXISTS idx_posts_root_id;

-- server/channels/db/migrations/postgres/000067_upgrade_channelmembers_v6.1.up.sql
DO $$
DECLARE 
    column_exist boolean := false;
BEGIN
SELECT count(*) != 0 INTO column_exist
    FROM information_schema.columns
    WHERE table_name = 'channelmembers'
    AND table_schema = current_schema()
    AND column_name = 'roles'
    AND NOT data_type = 'varchar(256)';
IF column_exist THEN
    ALTER TABLE channelmembers ALTER COLUMN roles TYPE varchar(256);
END IF;
END $$;

-- server/channels/db/migrations/postgres/000068_upgrade_teammembers_v6.1.up.sql
DO $$
DECLARE 
    column_exist boolean := false;
BEGIN
SELECT count(*) != 0 INTO column_exist
    FROM information_schema.columns
    WHERE table_name = 'teammembers'
    AND table_schema = current_schema()
    AND column_name = 'roles'
    AND NOT data_type = 'varchar(256)';
IF column_exist THEN
    ALTER TABLE teammembers ALTER COLUMN roles TYPE varchar(256);
END IF;
END $$;

-- server/channels/db/migrations/postgres/000069_upgrade_jobs_v6.1.up.sql
CREATE INDEX IF NOT EXISTS idx_jobs_status_type ON jobs(status, type);

-- server/channels/db/migrations/postgres/000070_upgrade_cte_v6.1.up.sql
DO $$
	<< migrate_cte >>
DECLARE
	column_exist boolean := FALSE;
BEGIN
	SELECT
		count(*) != 0 INTO column_exist
	FROM
		information_schema.columns
	WHERE
		table_name = 'channels'
		AND table_schema = current_schema()
		AND column_name = 'lastrootpostat';
	IF NOT column_exist THEN
		ALTER TABLE channels ADD COLUMN lastrootpostat bigint DEFAULT '0'::bigint;
		WITH q AS (
			SELECT
				Channels.Id channelid,
				COALESCE(MAX(Posts.CreateAt),
					0) AS lastrootpost
			FROM
				Channels
			LEFT JOIN Posts ON Channels.Id = Posts.ChannelId
		WHERE
			Posts.RootId = ''
		GROUP BY
			Channels.Id
)
UPDATE
	Channels
SET
	LastRootPostAt = q.lastrootpost
FROM
	q
WHERE
	q.channelid = Channels.Id;
END IF;
END migrate_cte
$$;

-- server/channels/db/migrations/postgres/000071_upgrade_sessions_v6.1.up.sql
DO $$
DECLARE 
    column_exist boolean := false;
BEGIN
SELECT count(*) != 0 INTO column_exist
    FROM information_schema.columns
    WHERE table_name = 'sessions'
    AND table_schema = current_schema()
    AND column_name = 'roles'
    AND NOT data_type = 'varchar(256)';
IF column_exist THEN
    ALTER TABLE sessions ALTER COLUMN roles TYPE varchar(256);
END IF;
END $$;

-- server/channels/db/migrations/postgres/000072_upgrade_schemes_v6.3.up.sql
ALTER TABLE schemes ADD COLUMN IF NOT EXISTS defaultplaybookadminrole VARCHAR(64) DEFAULT ''::character varying;
ALTER TABLE schemes ADD COLUMN IF NOT EXISTS defaultplaybookmemberrole VARCHAR(64) DEFAULT ''::character varying;
ALTER TABLE schemes ADD COLUMN IF NOT EXISTS defaultrunadminrole VARCHAR(64) DEFAULT ''::character varying;
ALTER TABLE schemes ADD COLUMN IF NOT EXISTS defaultrunmemberrole VARCHAR(64) DEFAULT ''::character varying;

-- server/channels/db/migrations/postgres/000073_upgrade_plugin_key_value_store_v6.3.up.sql
DO $$
DECLARE 
    column_exist boolean := false;
BEGIN
SELECT count(*) != 0 INTO column_exist
    FROM information_schema.columns
    WHERE table_name = 'pluginkeyvaluestore'
    AND table_schema = current_schema()
    AND column_name = 'pkey'
    AND NOT data_type = 'varchar(150)';
IF column_exist THEN
    ALTER TABLE pluginkeyvaluestore ALTER COLUMN pkey TYPE varchar(150);
END IF;
END $$;

-- server/channels/db/migrations/postgres/000074_upgrade_users_v6.3.up.sql
ALTER TABLE users DROP COLUMN IF EXISTS acceptedtermsofserviceid;

-- server/channels/db/migrations/postgres/000075_alter_upload_sessions_index.up.sql
DO $$
<<alter_index>>
DECLARE
    column_name text;
BEGIN
    select array_to_string(array_agg(a.attname), ', ') as column_name INTO column_name
    from
        pg_index ix,
        pg_attribute a
    where
        ix.indexrelid='idx_uploadsessions_user_id'::regclass
        and a.attrelid = ix.indrelid
        and a.attnum = ANY(ix.indkey);

    IF COALESCE (column_name, '') = text('type') THEN
        DROP INDEX IF EXISTS idx_uploadsessions_user_id;
        CREATE INDEX IF NOT EXISTS idx_uploadsessions_user_id on uploadsessions(userid);
    END IF;
END alter_index $$;
-- server/channels/db/migrations/postgres/000076_upgrade_lastrootpostat.up.sql
DO $$
BEGIN
	IF (
		SELECT count(*)
		FROM information_schema.columns
		WHERE table_schema=current_schema()
		AND table_name='channels'
		AND column_name='lastrootpostat'
		AND (column_default IS NULL OR column_default != '''0''::bigint')
	) = 1 THEN
		ALTER TABLE channels ALTER COLUMN lastrootpostat SET DEFAULT '0'::bigint;
	END IF;
END$$;

DO $$
BEGIN
	IF (
		SELECT count(*)
		FROM Channels
		WHERE LastRootPostAt IS NULL
	) > 0 THEN
		-- fixes migrate cte and sets the LastRootPostAt for channels that don't have it set
		WITH q AS (
			SELECT
				Channels.Id channelid,
				COALESCE(MAX(Posts.CreateAt), 0) AS lastrootpost
			FROM
				Channels
			LEFT JOIN
				Posts
			ON
				Channels.Id = Posts.ChannelId
			WHERE
				Posts.RootId = ''
			GROUP BY
				Channels.Id
		)
		UPDATE
			Channels
		SET
			LastRootPostAt = q.lastrootpost
		FROM
			q
		WHERE
			q.channelid = Channels.Id AND Channels.LastRootPostAt IS NULL;

		-- sets LastRootPostAt to 0, for channels with no posts
		UPDATE Channels SET LastRootPostAt=0 WHERE LastRootPostAt IS NULL;
	END IF;
END $$;

-- server/channels/db/migrations/postgres/000077_upgrade_users_v6.5.up.sql
ALTER TABLE users DROP COLUMN IF EXISTS acceptedservicetermsid;

-- server/channels/db/migrations/postgres/000078_create_oauth_mattermost_app_id.up.sql
ALTER TABLE OAuthApps ADD COLUMN IF NOT EXISTS MattermostAppID varchar(32);

-- server/channels/db/migrations/postgres/000079_usergroups_displayname_index.up.sql
CREATE INDEX IF NOT EXISTS idx_usergroups_displayname ON usergroups(displayname);
-- server/channels/db/migrations/postgres/000080_posts_createat_id.up.sql
CREATE INDEX IF NOT EXISTS idx_posts_create_at_id on posts(createat, id);
-- server/channels/db/migrations/postgres/000081_threads_deleteat.up.sql
-- Replaced by 000083_threads_threaddeleteat.up.sql

-- server/channels/db/migrations/postgres/000082_upgrade_oauth_mattermost_app_id.up.sql
DO $$
DECLARE
    column_exist boolean := false;
BEGIN
SELECT count(*) != 0 INTO column_exist
    FROM information_schema.columns
    WHERE table_name = 'oauthapps'
    AND table_schema = current_schema()
    AND column_name = 'mattermostappid';
IF column_exist THEN
    UPDATE OAuthApps SET MattermostAppID = '' WHERE MattermostAppID IS NULL;
    ALTER TABLE OAuthApps ALTER COLUMN MattermostAppID SET DEFAULT '';
    ALTER TABLE OAuthApps ALTER COLUMN MattermostAppID SET NOT NULL;
END IF;
END $$;

-- server/channels/db/migrations/postgres/000083_threads_threaddeleteat.up.sql
-- Drop any existing DeleteAt column from 000081_threads_deleteat.up.sql
ALTER TABLE threads DROP COLUMN IF EXISTS deleteat;

ALTER TABLE threads ADD COLUMN IF NOT EXISTS threaddeleteat bigint;
UPDATE threads SET threaddeleteat = posts.deleteat FROM posts WHERE threads.threaddeleteat IS NULL AND posts.id = threads.postid;

-- server/channels/db/migrations/postgres/000084_recent_searches.up.sql
-- This table is unused, and will be dropped in a future ESR.
CREATE TABLE IF NOT EXISTS recentsearches (
    userid CHAR(26),
    searchpointer int,
    query jsonb,
    createat bigint NOT NULL,
    PRIMARY KEY (userid, searchpointer)
);

-- server/channels/db/migrations/postgres/000085_fileinfo_add_archived_column.up.sql
ALTER TABLE fileinfo ADD COLUMN IF NOT EXISTS archived boolean NOT NULL DEFAULT false;

-- server/channels/db/migrations/postgres/000086_add_cloud_limits_archived.up.sql
ALTER TABLE teams ADD COLUMN IF NOT EXISTS CloudLimitsArchived bool NOT NULL DEFAULT FALSE;

-- server/channels/db/migrations/postgres/000087_sidebar_categories_index.up.sql
CREATE INDEX IF NOT EXISTS idx_sidebarcategories_userid_teamid on sidebarcategories (userid, teamid);
-- server/channels/db/migrations/postgres/000088_remaining_migrations.up.sql
DROP TABLE IF EXISTS jobstatuses;

DROP TABLE IF EXISTS passwordrecovery;

DO $$
<<migrate_theme>>
DECLARE
    col_exist boolean := false;
BEGIN
    SELECT count(*) != 0 INTO col_exist
    FROM information_schema.columns
    WHERE table_name = 'users'
    AND table_schema = current_schema()
    AND column_name = 'themeprops';

    IF col_exist THEN
		INSERT INTO
			preferences(userid, category, name, value)
		SELECT
			id, '', '', themeprops
		FROM
			users
		WHERE
			users.themeprops != 'null';

        ALTER TABLE users DROP COLUMN themeprops;
    END IF;
END migrate_theme $$;

-- server/channels/db/migrations/postgres/000089_add-channelid-to-reaction.up.sql
ALTER TABLE reactions ADD COLUMN IF NOT EXISTS channelid varchar(26) NOT NULL DEFAULT '';
UPDATE reactions SET channelid = COALESCE((select channelid from posts where posts.id = reactions.postid), '') WHERE channelid='';
CREATE INDEX IF NOT EXISTS idx_reactions_channel_id on reactions (channelid);

-- server/channels/db/migrations/postgres/000090_create_enums.up.sql
DO
$$
BEGIN
  IF NOT EXISTS (SELECT * FROM pg_type typ
                            INNER JOIN pg_namespace nsp ON nsp.oid = typ.typnamespace
                        WHERE nsp.nspname = current_schema()
                            AND typ.typname = 'channel_type') THEN
    CREATE TYPE channel_type AS ENUM ('P', 'G', 'O', 'D');
  END IF;
END;
$$
LANGUAGE plpgsql;

ALTER TABLE channels alter column type type channel_type using type::channel_type;

DO
$$
BEGIN
  IF NOT EXISTS (SELECT * FROM pg_type typ
                            INNER JOIN pg_namespace nsp ON nsp.oid = typ.typnamespace
                        WHERE nsp.nspname = current_schema()
                            AND typ.typname = 'team_type') THEN
    CREATE TYPE team_type AS ENUM ('I', 'O');
  END IF;
END;
$$
LANGUAGE plpgsql;

ALTER TABLE teams alter column type type team_type using type::team_type;

DO
$$
BEGIN
  IF NOT EXISTS (SELECT * FROM pg_type typ
                            INNER JOIN pg_namespace nsp ON nsp.oid = typ.typnamespace
                        WHERE nsp.nspname = current_schema()
                            AND typ.typname = 'upload_session_type') THEN
    CREATE TYPE upload_session_type AS ENUM ('attachment', 'import');
  END IF;
END;
$$
LANGUAGE plpgsql;

ALTER TABLE uploadsessions alter column type type upload_session_type using type::upload_session_type;

-- server/channels/db/migrations/postgres/000091_create_post_reminder.up.sql
CREATE TABLE IF NOT EXISTS postreminders (
    postid varchar(26) NOT NULL,
    userid varchar(26) NOT NULL,
    targettime bigint,
    PRIMARY KEY (postid, userid)
);

CREATE INDEX IF NOT EXISTS idx_postreminders_targettime ON postreminders(targettime);
-- server/channels/db/migrations/postgres/000092_add_createat_to_teamembers.up.sql
ALTER TABLE teammembers ADD COLUMN IF NOT EXISTS createat bigint DEFAULT 0;
CREATE INDEX IF NOT EXISTS idx_teammembers_createat on teammembers (createat);

-- server/channels/db/migrations/postgres/000093_notify_admin.up.sql
CREATE TABLE IF NOT EXISTS NotifyAdmin (
    UserId varchar(26) NOT NULL,
    CreateAt bigint DEFAULT NULL,
    RequiredPlan varchar(26) NOT NULL,
    RequiredFeature varchar(100) NOT NULL,
    Trial BOOLEAN NOT NULL,
    PRIMARY KEY (UserId, RequiredFeature, RequiredPlan)
);

-- server/channels/db/migrations/postgres/000094_threads_teamid.up.sql
-- Replaced by 000096_threads_threadteamid.up.sql

-- server/channels/db/migrations/postgres/000095_remove_posts_parentid.up.sql
-- While upgrading from 5.x to 6.x with manual queries, there is a chance that this
-- migration is skipped. In that case, we need to make sure that the column is dropped.

ALTER TABLE posts DROP COLUMN IF EXISTS parentid;

-- server/channels/db/migrations/postgres/000096_threads_threadteamid.up.sql
-- Drop any existing TeamId column from 000094_threads_teamid.up.sql
 ALTER TABLE threads DROP COLUMN IF EXISTS teamid;

ALTER TABLE threads ADD COLUMN IF NOT EXISTS threadteamid VARCHAR(26);
UPDATE threads SET threadteamid = channels.teamid FROM channels WHERE threads.threadteamid IS NULL AND channels.id = threads.channelid;

-- server/channels/db/migrations/postgres/000097_create_posts_priority.up.sql
CREATE TABLE IF NOT EXISTS postspriority (
    postid VARCHAR(26) PRIMARY KEY,
    channelid VARCHAR(26) NOT NULL,
    priority VARCHAR(32) NOT NULL,
    requestedack boolean,
    persistentnotifications boolean
);

ALTER TABLE channelmembers ADD COLUMN IF NOT EXISTS urgentmentioncount bigint;

-- server/channels/db/migrations/postgres/000098_create_post_acknowledgements.up.sql
CREATE TABLE IF NOT EXISTS postacknowledgements(
    postid VARCHAR(26) NOT NULL,
    userid VARCHAR(26) NOT NULL,
    acknowledgedat bigint,
    PRIMARY KEY (postid, userid)
);

-- server/channels/db/migrations/postgres/000099_create_drafts.up.sql
CREATE TABLE IF NOT EXISTS drafts (
    createat bigint,
    updateat bigint,
    deleteat bigint,
    userid VARCHAR(26),
    channelid VARCHAR(26),
    rootid VARCHAR(26) DEFAULT '',
    message VARCHAR(65535),
    props VARCHAR(8000),
    fileids VARCHAR(300),
    PRIMARY KEY (userid, channelid, rootid)
);

-- server/channels/db/migrations/postgres/000100_add_draft_priority_column.up.sql
ALTER TABLE drafts ADD COLUMN IF NOT EXISTS priority text;

-- server/channels/db/migrations/postgres/000101_create_true_up_review_history.up.sql
CREATE TABLE IF NOT EXISTS trueupreviewhistory (
	duedate bigint,
	completed boolean,
    PRIMARY KEY (duedate)
);

-- server/channels/db/migrations/postgres/000102_posts_originalid_index.up.sql
CREATE INDEX IF NOT EXISTS idx_posts_original_id ON Posts(originalid);

-- server/channels/db/migrations/postgres/000103_add_sentat_to_notifyadmin.up.sql
ALTER TABLE NotifyAdmin ADD COLUMN IF NOT EXISTS SentAt bigint DEFAULT NULL;

-- server/channels/db/migrations/postgres/000104_upgrade_notifyadmin.up.sql
ALTER TABLE NotifyAdmin ALTER COLUMN RequiredFeature TYPE VARCHAR(255);
ALTER TABLE NotifyAdmin ALTER COLUMN RequiredPlan TYPE VARCHAR(100);

-- server/channels/db/migrations/postgres/000105_remove_tokens.up.sql
DO $$
BEGIN
WITH oauthDelete AS (
	DELETE FROM oauthaccessdata o
	WHERE NOT EXISTS (
		SELECT p.* FROM preferences p
		WHERE o.clientid = p.name AND o.userid = p.userid AND p.category = 'oauth_app'
	)
	RETURNING o.token
)
DELETE FROM sessions s WHERE s.token in (select oauthDelete.token from oauthDelete);
END $$;

-- server/channels/db/migrations/postgres/000106_fileinfo_channelid.up.sql
ALTER TABLE fileinfo ADD COLUMN IF NOT EXISTS channelid varchar(26);
UPDATE fileinfo SET channelid = posts.channelid FROM posts WHERE fileinfo.channelid IS NULL AND fileinfo.postid = posts.id;
CREATE INDEX IF NOT EXISTS idx_fileinfo_channel_id_create_at ON fileinfo(channelid, createat);

-- server/channels/db/migrations/postgres/000107_threadmemberships_cleanup.up.sql
DELETE FROM threadmemberships WHERE (postid, userid) IN (
    SELECT
        threadmemberships.postid,
        threadmemberships.userid
    FROM
        threadmemberships
        JOIN threads ON threads.postid = threadmemberships.postid
        LEFT JOIN channelmembers ON channelmembers.userid = threadmemberships.userid
            AND threads.channelid = channelmembers.channelid
    WHERE
        channelmembers.channelid IS NULL
);

-- server/channels/db/migrations/postgres/000108_remove_orphaned_oauth_preferences.up.sql
DO $$
DECLARE 
    preferences_exist boolean := false;
BEGIN
    SELECT count(p.*) != 0 INTO preferences_exist FROM preferences p
    WHERE (
        (NOT EXISTS (
            SELECT o.* FROM oauthaccessdata o
            WHERE o.clientid = p.name AND o.userid = p.userid AND p.category = 'oauth_app'
        ))
        AND 
        (NOT EXISTS (
            SELECT oa.* FROM oauthauthdata oa
            WHERE oa.clientid = p.name AND oa.userid = p.userid AND p.category = 'oauth_app'
        ))
    ) 
    AND p.category = 'oauth_app';
IF preferences_exist THEN
    DELETE FROM preferences p
    WHERE (
        (NOT EXISTS (
            SELECT o.* FROM oauthaccessdata o
            WHERE o.clientid = p.name AND o.userid = p.userid AND p.category = 'oauth_app'
        ))
        AND 
        (NOT EXISTS (
            SELECT oa.* FROM oauthauthdata oa
            WHERE oa.clientid = p.name AND oa.userid = p.userid AND p.category = 'oauth_app'
        ))
    ) 
    AND p.category = 'oauth_app';
END IF;
END $$;

-- server/channels/db/migrations/postgres/000109_create_persistent_notifications.up.sql
CREATE TABLE IF NOT EXISTS persistentnotifications (
    postid VARCHAR(26) PRIMARY KEY,
    createat bigint,
    lastsentat bigint,
    deleteat bigint,
    sentcount smallint
);

-- server/channels/db/migrations/postgres/000111_update_vacuuming.up.sql
alter table posts set (autovacuum_vacuum_scale_factor = 0.1, autovacuum_analyze_scale_factor = 0.05);
alter table threadmemberships set (autovacuum_vacuum_scale_factor = 0.1, autovacuum_analyze_scale_factor = 0.05);
alter table fileinfo set (autovacuum_vacuum_scale_factor = 0.1, autovacuum_analyze_scale_factor = 0.05);
alter table preferences set (autovacuum_vacuum_scale_factor = 0.1, autovacuum_analyze_scale_factor = 0.05);

-- server/channels/db/migrations/postgres/000112_rework_desktop_tokens.up.sql
DROP INDEX IF EXISTS idx_desktoptokens_createat;
DROP TABLE IF EXISTS desktoptokens;

CREATE TABLE IF NOT EXISTS desktoptokens (
    token VARCHAR(64) NOT NULL,
    createat BIGINT NOT NULL,
    userid VARCHAR(26) NOT NULL,    
    PRIMARY KEY (token)
);

CREATE INDEX IF NOT EXISTS idx_desktoptokens_token_createat ON desktoptokens(token, createat)

-- server/channels/db/migrations/postgres/000113_create_retentionidsfordeletion_table.up.sql
CREATE TABLE IF NOT EXISTS retentionidsfordeletion (
    id varchar(26) PRIMARY KEY,
    tablename varchar(64),
    ids varchar(26)[]
);

CREATE INDEX IF NOT EXISTS idx_retentionidsfordeletion_tablename ON retentionidsfordeletion (tablename);

-- server/channels/db/migrations/postgres/000114_sharedchannelremotes_drop_nextsyncat_description.up.sql
ALTER TABLE sharedchannelremotes DROP COLUMN IF EXISTS nextsyncat;
ALTER TABLE sharedchannelremotes DROP COLUMN IF EXISTS description;

-- server/channels/db/migrations/postgres/000115_user_reporting_changes.up.sql
ALTER TABLE users ADD COLUMN IF NOT EXISTS lastlogin bigint NOT NULL DEFAULT 0;

CREATE MATERIALIZED VIEW IF NOT EXISTS poststats AS
SELECT userid, to_timestamp(createat/1000)::date as day, COUNT(*) as numposts, MAX(CreateAt) as lastpostdate
FROM posts 
GROUP BY userid, day
;

-- server/channels/db/migrations/postgres/000116_create_outgoing_oauth_connections.up.sql
CREATE TYPE outgoingoauthconnections_granttype AS ENUM ('client_credentials', 'password');

CREATE TABLE IF NOT EXISTS outgoingoauthconnections (
    id varchar(26) PRIMARY KEY,
    name varchar(64),
    creatorid VARCHAR(26),
    createat bigint,
    updateat bigint,
    clientid varchar(255),
    clientsecret varchar(255),
    credentialsusername varchar(255),
    credentialspassword varchar(255),
    oauthtokenurl text,
    granttype outgoingoauthconnections_granttype DEFAULT 'client_credentials',
    audiences VARCHAR(1024)
);

CREATE INDEX IF NOT EXISTS idx_outgoingoauthconnections_name ON outgoingoauthconnections (name);

-- server/channels/db/migrations/postgres/000117_msteams_shared_channels.up.sql
ALTER TABLE RemoteClusters ADD COLUMN IF NOT EXISTS PluginID VARCHAR(190) NOT NULL DEFAULT '';

ALTER TABLE SharedChannelRemotes ADD COLUMN IF NOT EXISTS LastPostCreateAt bigint NOT NULL DEFAULT 0;

ALTER TABLE SharedChannelRemotes ADD COLUMN IF NOT EXISTS LastPostCreateID VARCHAR(26);


-- server/channels/db/migrations/postgres/000118_create_index_poststats.up.sql
-- morph:nontransactional
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_poststats_userid ON poststats(userid)
-- server/channels/db/migrations/postgres/000119_msteams_shared_channels_opts.up.sql
ALTER TABLE RemoteClusters ADD COLUMN IF NOT EXISTS Options SMALLINT NOT NULL DEFAULT 0;


-- server/channels/db/migrations/postgres/000120_create_channelbookmarks_table.up.sql
DO
$$
BEGIN
  IF NOT EXISTS (SELECT * FROM pg_type typ
                            INNER JOIN pg_namespace nsp ON nsp.oid = typ.typnamespace
                        WHERE nsp.nspname = current_schema()
                            AND typ.typname = 'channel_bookmark_type') THEN
    CREATE TYPE channel_bookmark_type AS ENUM ('link', 'file');
  END IF;
END;
$$
LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS channelbookmarks (
    id varchar(26) PRIMARY KEY,
    ownerid varchar(26) NOT NULL,
    channelid varchar(26) NOT NULL,
    fileinfoid varchar(26) DEFAULT NULL,
    createat bigint DEFAULT 0,
    updateat bigint DEFAULT 0,
    deleteat bigint DEFAULT 0,
    displayname text DEFAULT '',
    sortorder integer DEFAULT 0,
    linkurl text DEFAULT NULL,
    imageurl text DEFAULT NULL,
    emoji varchar(64) DEFAULT NULL,
    type channel_bookmark_type DEFAULT 'link',
    originalid varchar(26) DEFAULT NULL,
    parentid varchar(26) DEFAULT NULL
);

CREATE INDEX IF NOT EXISTS idx_channelbookmarks_channelid ON channelbookmarks (channelid);
CREATE INDEX IF NOT EXISTS idx_channelbookmarks_update_at ON channelbookmarks (updateat);
CREATE INDEX IF NOT EXISTS idx_channelbookmarks_delete_at ON channelbookmarks (deleteat);

-- server/channels/db/migrations/postgres/000121_remove_true_up_review_history.up.sql
DROP TABLE IF EXISTS trueupreviewhistory;
-- server/channels/db/migrations/postgres/000122_preferences_value_length.up.sql
ALTER TABLE preferences ALTER COLUMN value TYPE text;

-- server/channels/db/migrations/postgres/000123_remove_upload_file_permission.up.sql
DO $$
<<remove_upload_file_permission>>
DECLARE
  rows_updated integer;
BEGIN
  LOOP
    WITH table_holder AS (
      SELECT id FROM roles
          WHERE permissions ~~ '%upload_file%' AND permissions !~ 'create_post($|\s)'
          ORDER BY id ASC limit 100
    )

    UPDATE Roles r set permissions = REGEXP_REPLACE(permissions, 'upload_file($|\s)', '') 
        WHERE r.id in (SELECT id FROM table_holder);
    GET DIAGNOSTICS rows_updated = ROW_COUNT;
    EXIT WHEN rows_updated < 100;
  END LOOP;
END remove_upload_file_permission $$;

-- server/channels/db/migrations/postgres/000124_remove_manage_team_permission.up.sql
DO $$
<<remove_manage_team_permission>>
DECLARE
  rows_updated integer;
BEGIN
  LOOP
    WITH table_holder AS (
      SELECT id FROM roles
        WHERE Permissions ~ 'manage_team($|\s)'
            AND Permissions !~~ '%sysconsole_write_user_management_teams%'
            AND (Permissions ~~ '%sysconsole_write_user_management_channels%'
            OR Permissions ~~ '%sysconsole_write_user_management_groups%')
        ORDER BY id ASC limit 100
    )

    UPDATE Roles r set permissions = REGEXP_REPLACE(permissions, 'manage_team($|\s)', '') 
        WHERE r.id in (SELECT id FROM table_holder);
    GET DIAGNOSTICS rows_updated = ROW_COUNT;
    EXIT WHEN rows_updated < 100;
  END LOOP;
END remove_manage_team_permission $$;

-- server/channels/db/migrations/postgres/000125_remoteclusters_add_default_team_id.up.sql
ALTER TABLE remoteclusters ADD COLUMN IF NOT EXISTS defaultteamid character varying(26) DEFAULT '';

-- server/channels/db/migrations/postgres/000126_sharedchannels_remotes_add_deleteat.up.sql
DROP INDEX IF EXISTS remote_clusters_site_url_unique;
ALTER TABLE remoteclusters ADD COLUMN IF NOT EXISTS deleteat bigint DEFAULT 0;

ALTER TABLE sharedchannelremotes ADD COLUMN IF NOT EXISTS deleteat bigint DEFAULT 0;

-- server/channels/db/migrations/postgres/000127_add_mfa_used_ts_to_users.up.sql
ALTER TABLE Users ADD COLUMN IF NOT EXISTS MfaUsedTimestamps jsonb NULL;

-- server/channels/db/migrations/postgres/000128_create_scheduled_posts.up.sql
CREATE TABLE IF NOT EXISTS scheduledposts (
	id VARCHAR(26) PRIMARY KEY,
	createat bigint,
	updateat bigint,
	userid VARCHAR(26) NOT NULL,
	channelid VARCHAR(26) NOT NULL,
	rootid VARCHAR(26),
	message VARCHAR(65535),
	props VARCHAR(8000),
	fileids VARCHAR(300),
	priority text,
	scheduledat bigint NOT NULL,
	processedat bigint,
	errorcode VARCHAR(200)
);

CREATE INDEX IF NOT EXISTS idx_scheduledposts_userid_channel_id_scheduled_at ON ScheduledPosts (UserId, ChannelId, ScheduledAt);

-- server/channels/db/migrations/postgres/000129_add_property_system_architecture.up.sql
CREATE TABLE IF NOT EXISTS PropertyGroups (
	ID varchar(26) PRIMARY KEY,
	Name varchar(64) NOT NULL,
	UNIQUE(Name)
);

DO
$$
BEGIN
  IF NOT EXISTS (SELECT * FROM pg_type typ
                            INNER JOIN pg_namespace nsp ON nsp.oid = typ.typnamespace
                        WHERE nsp.nspname = current_schema()
                            AND typ.typname = 'property_field_type') THEN
    CREATE TYPE property_field_type AS ENUM (
        'text',
        'select',
        'multiselect',
        'date',
        'user',
        'multiuser'
    );
  END IF;
END;
$$
LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS PropertyFields (
	ID varchar(26) PRIMARY KEY,
	GroupID varchar(26) NOT NULL,
	Name varchar(255) NOT NULL,
	Type property_field_type,
	Attrs jsonb,
	TargetID varchar(255),
	TargetType varchar(255),
	CreateAt bigint NOT NULL,
	UpdateAt bigint NOT NULL,
	DeleteAt bigint NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_propertyfields_unique ON PropertyFields (GroupID, TargetID, Name) WHERE DeleteAt = 0;

CREATE TABLE IF NOT EXISTS PropertyValues (
	ID varchar(26) PRIMARY KEY,
	TargetID varchar(255) NOT NULL,
	TargetType varchar(255) NOT NULL,
	GroupID varchar(26) NOT NULL,
	FieldID varchar(26) NOT NULL,
	Value jsonb NOT NULL,
	CreateAt bigint NOT NULL,
	UpdateAt bigint NOT NULL,
	DeleteAt bigint NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_propertyvalues_unique ON PropertyValues (GroupID, TargetID, FieldID) WHERE DeleteAt = 0;
CREATE INDEX IF NOT EXISTS idx_propertyvalues_targetid_groupid ON PropertyValues (TargetID, GroupID);

-- server/channels/db/migrations/postgres/000130_system_console_stats.up.sql
CREATE MATERIALIZED VIEW IF NOT EXISTS posts_by_team_day as
SELECT to_timestamp(p.createat/1000)::date as day, COUNT(*) as num, teamid
FROM posts p JOIN channels c on p.channelid=c.id
GROUP BY day, c.teamid;

CREATE MATERIALIZED VIEW IF NOT EXISTS bot_posts_by_team_day as
SELECT to_timestamp(p.createat/1000)::date as day, COUNT(*) as num, teamid
FROM posts p
JOIN Bots b ON p.UserId = b.Userid
JOIN channels c on p.channelid=c.id
GROUP BY day, c.teamid;

CREATE MATERIALIZED VIEW IF NOT EXISTS file_stats as
SELECT COUNT(*) as num, COALESCE(SUM(Size), 0) as usage
FROM fileinfo
WHERE DeleteAt = 0;

-- server/channels/db/migrations/postgres/000131_create_index_pagination_on_property_values.up.sql
-- morph:nontransactional
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_propertyvalues_create_at_id ON PropertyValues(CreateAt, ID)

-- server/channels/db/migrations/postgres/000132_create_index_pagination_on_property_fields.up.sql
-- morph:nontransactional
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_propertyfields_create_at_id ON PropertyFields(CreateAt, ID)

-- server/channels/db/migrations/postgres/000133_add_channel_banner_fields.up.sql
ALTER TABLE channels ADD COLUMN IF NOT EXISTS bannerinfo jsonb;

-- server/channels/db/migrations/postgres/000134_create_access_control_policies.up.sql
CREATE TABLE IF NOT EXISTS AccessControlPolicies (
    ID varchar(26) PRIMARY KEY,
    Name varchar(128) NOT NULL,
    Type varchar(128) NOT NULL,
    Active bool NOT NULL,
    CreateAt bigint NOT NULL,
    Revision int NOT NULL,
    Version varchar(8) NOT NULL,
    Data jsonb,
    Props jsonb
);

CREATE TABLE IF NOT EXISTS AccessControlPolicyHistory (
    ID varchar(26) NOT NULL,
    Name varchar(128) NOT NULL,
    Type varchar(128) NOT NULL,
    CreateAt bigint NOT NULL,
    Revision int NOT NULL,
    Version varchar(8) NOT NULL,
    Data jsonb,
    Props jsonb,
    PRIMARY KEY (ID, Revision)
);

-- server/channels/db/migrations/postgres/000135_sidebarchannels_categoryid.up.sql
-- morph:nontransactional
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_sidebarchannels_categoryid ON sidebarchannels(categoryid);

-- server/channels/db/migrations/postgres/000136_create_attribute_view.up.sql
-- This migration is converted to be no-op due to an error in the original migration.
-- The new migration for this change is 000137_update_attribute_view.up.sql.

-- server/channels/db/migrations/postgres/000137_update_attribute_view.up.sql
DROP MATERIALIZED VIEW IF EXISTS AttributeView;

CREATE OR REPLACE PROCEDURE create_attribute_view()
LANGUAGE plpgsql
AS $$
BEGIN
    EXECUTE '
    CREATE MATERIALIZED VIEW IF NOT EXISTS AttributeView AS
	SELECT
        pv.GroupID,
        pv.TargetID,
        pv.TargetType,
        jsonb_object_agg(
            pf.Name,
            CASE
                WHEN pf.Type = ''select'' THEN (
                    SELECT to_jsonb(options.name)
                    FROM jsonb_to_recordset(pf.Attrs->''options'') AS options(id text, name text)
                    WHERE options.id = pv.Value #>> ''{}''
                    LIMIT 1
                )
                WHEN pf.Type = ''multiselect'' AND jsonb_typeof(pv.Value) = ''array'' THEN (
                    SELECT jsonb_agg(option_names.name)
                    FROM jsonb_array_elements_text(pv.Value) AS option_id
                    JOIN jsonb_to_recordset(pf.Attrs->''options'') AS option_names(id text, name text)
                    ON option_id = option_names.id
                )
                ELSE pv.Value
            END
        ) AS Attributes    FROM PropertyValues pv
    LEFT JOIN PropertyFields pf ON pf.ID = pv.FieldID
    WHERE (pv.DeleteAt = 0 OR pv.DeleteAt IS NULL) AND (pf.DeleteAt = 0 OR pf.DeleteAt IS NULL)
    GROUP BY pv.GroupID, pv.TargetID, pv.TargetType
        ';
END;
$$;

call create_attribute_view();
DROP PROCEDURE create_attribute_view();

-- server/channels/db/migrations/postgres/000138_add_default_category_name_to_channel.up.sql
ALTER TABLE channels ADD COLUMN IF NOT EXISTS DefaultCategoryName varchar(64) NOT NULL DEFAULT '';
-- server/channels/db/migrations/postgres/000139_remoteclusters_add_last_global_user_sync_at.up.sql
ALTER TABLE remoteclusters ADD COLUMN IF NOT EXISTS lastglobalusersyncat bigint DEFAULT 0;
-- server/channels/db/migrations/postgres/000140_add_lastmemberssyncat_to_sharedchannelremotes.up.sql
ALTER TABLE sharedchannelremotes ADD COLUMN IF NOT EXISTS lastmemberssyncat bigint DEFAULT 0;
ALTER TABLE sharedchannelusers ADD COLUMN IF NOT EXISTS lastmembershipsyncat bigint DEFAULT 0;
-- server/channels/db/migrations/postgres/000141_add_remoteid_channelid_to_post_acknowledgements.up.sql
ALTER TABLE postacknowledgements ADD COLUMN IF NOT EXISTS remoteid VARCHAR(26) DEFAULT '';
ALTER TABLE postacknowledgements ADD COLUMN IF NOT EXISTS channelid VARCHAR(26) DEFAULT '';
-- server/channels/db/migrations/postgres/000142_create_content_flagging_tables.up.sql
CREATE TABLE IF NOT EXISTS ContentFlaggingCommonReviewers (
	UserId VARCHAR(26) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS ContentFlaggingTeamSettings (
	TeamId VARCHAR(26) PRIMARY KEY,
	Enabled BOOLEAN
);

CREATE TABLE IF NOT EXISTS ContentFlaggingTeamReviewers (
	TeamId VARCHAR(26),
	UserId VARCHAR(26),
	PRIMARY KEY (TeamId, UserId)
);

-- server/channels/db/migrations/postgres/000143_content_flagging_table_index.up.sql
-- morph:nontransactional
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_contentflaggingteamreviewers_userid ON ContentFlaggingTeamReviewers (userid);

-- server/channels/db/migrations/postgres/000144_add_dcr_fields_to_oauth_apps.up.sql
-- Add DCR (Dynamic Client Registration) fields to OAuthApps table

ALTER TABLE oauthapps ADD COLUMN IF NOT EXISTS isdynamicallyregistered BOOLEAN DEFAULT FALSE;

-- server/channels/db/migrations/postgres/000145_add_pkce_to_oauthauthdata.up.sql
ALTER TABLE oauthauthdata ADD COLUMN IF NOT EXISTS codechallenge varchar(128) DEFAULT '';
ALTER TABLE oauthauthdata ADD COLUMN IF NOT EXISTS codechallengemethod varchar(10) DEFAULT '';

-- server/channels/db/migrations/postgres/000146_add_audience_and_resource_to_oauth.up.sql
ALTER TABLE oauthaccessdata ADD COLUMN IF NOT EXISTS audience varchar(512) DEFAULT '';
ALTER TABLE oauthauthdata ADD COLUMN IF NOT EXISTS resource varchar(512) DEFAULT '';

-- server/channels/db/migrations/postgres/000147_create_autotranslation_tables.up.sql
-- Create translations table
CREATE TABLE IF NOT EXISTS translations (
    objectId            varchar(26)    NOT NULL,    -- object ID (e.g., post ID)
    dstLang             varchar        NOT NULL,    -- ISO code from user preference
    objectType          varchar        NULL,         -- e.g., 'post' (object-agnostic) if NULL assume "post"
    providerId          varchar        NOT NULL,    -- 'agents' | 'libretranslate' | ...
    normHash            char(64)       NOT NULL,    -- sha256 (hex) of normalized source
    text                text           NOT NULL,    -- translated text (rehydrated)
    confidence          real                     ,  -- provider confidence 0..1 (nullable)
    meta                jsonb                    ,  -- provider metadata (nullable)
    updateAt            bigint         NOT NULL,    -- epoch millis
    PRIMARY KEY (objectId, dstLang)
);

-- Index for recency and lookup performance
CREATE INDEX IF NOT EXISTS idx_translations_updateat
    ON translations (updateAt DESC);

-- Add autotranslation boolean column to channels table
ALTER TABLE channels
    ADD COLUMN IF NOT EXISTS autotranslation boolean NOT NULL DEFAULT false;

-- Add autotranslation boolean column to channelmembers table
ALTER TABLE channelmembers
    ADD COLUMN IF NOT EXISTS autotranslation boolean NOT NULL DEFAULT false;

-- Hot path index: Members opted in for a channel
-- Partial index only includes rows where autotranslation is enabled for performance
CREATE INDEX IF NOT EXISTS idx_channelmembers_autotranslation_enabled
    ON channelmembers (channelid)
    WHERE autotranslation = true;

-- Index for efficient channel autotranslation lookups
CREATE INDEX IF NOT EXISTS idx_channels_autotranslation_enabled
    ON channels (id)
    WHERE autotranslation = true;

-- Covering index for GetActiveDestinationLanguages query
-- Allows index-only scans when fetching user locales (avoids heap access)
CREATE INDEX IF NOT EXISTS idx_users_id_locale
    ON users (id, locale);

-- server/channels/db/migrations/postgres/000148_add_burn_on_read_messages.up.sql
CREATE TABLE IF NOT EXISTS ReadReceipts (
    PostId VARCHAR(26) NOT NULL,
    UserId VARCHAR(26) NOT NULL,
    ExpireAt bigint NOT NULL,
    PRIMARY KEY (PostId, UserId)
);

CREATE INDEX IF NOT EXISTS idx_read_receipts_post_id ON ReadReceipts(PostId);
CREATE INDEX IF NOT EXISTS idx_read_receipts_user_id_post_id_expire_at ON ReadReceipts(UserId, PostId, ExpireAt);

CREATE TABLE IF NOT EXISTS TemporaryPosts (
    PostId VARCHAR(26) PRIMARY KEY,
    Type VARCHAR(26) NOT NULL,
    ExpireAt BIGINT NOT NULL,
    Message VARCHAR(65535),
    FileIds VARCHAR(300)
);

CREATE INDEX IF NOT EXISTS idx_temporary_posts_expire_at ON TemporaryPosts(expireat);

ALTER TABLE drafts ADD COLUMN IF NOT EXISTS Type text;
ALTER TABLE scheduledposts ADD COLUMN IF NOT EXISTS Type text;

-- server/channels/db/migrations/postgres/000149_create_recaps.up.sql
-- Recaps table: stores recap metadata
CREATE TABLE IF NOT EXISTS Recaps (
    Id VARCHAR(26) PRIMARY KEY,
    UserId VARCHAR(26) NOT NULL,
    Title VARCHAR(255) NOT NULL,
    CreateAt BIGINT NOT NULL,
    UpdateAt BIGINT NOT NULL,
    DeleteAt BIGINT NOT NULL,
    TotalMessageCount INT NOT NULL,
    Status VARCHAR(32) NOT NULL,
    ReadAt BIGINT DEFAULT 0 NOT NULL,
    BotID VARCHAR(26) DEFAULT '' NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_recaps_user_id ON Recaps(UserId);
CREATE INDEX IF NOT EXISTS idx_recaps_create_at ON Recaps(CreateAt);
CREATE INDEX IF NOT EXISTS idx_recaps_user_id_delete_at ON Recaps(UserId, DeleteAt);
CREATE INDEX IF NOT EXISTS idx_recaps_user_id_read_at ON Recaps(UserId, ReadAt);
CREATE INDEX IF NOT EXISTS idx_recaps_bot_id ON Recaps(BotID);

-- RecapChannels table: stores per-channel summaries
CREATE TABLE IF NOT EXISTS RecapChannels (
    Id VARCHAR(26) PRIMARY KEY,
    RecapId VARCHAR(26) NOT NULL,
    ChannelId VARCHAR(26) NOT NULL,
    ChannelName VARCHAR(64) NOT NULL,
    Highlights TEXT,
    ActionItems TEXT,
    SourcePostIds TEXT,
    CreateAt BIGINT NOT NULL,
    FOREIGN KEY (RecapId) REFERENCES Recaps(Id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_recap_channels_recap_id ON RecapChannels(RecapId);
CREATE INDEX IF NOT EXISTS idx_recap_channels_channel_id ON RecapChannels(ChannelId);



-- server/channels/db/migrations/postgres/000150_add_translation_state.up.sql
-- No default value - all inserts must explicitly provide a state
ALTER TABLE translations 
ADD COLUMN IF NOT EXISTS state varchar(20) NOT NULL;

-- Create partial index for non-terminal states (processing, unavailable)
-- This index is only for states that need monitoring/cleanup
CREATE INDEX IF NOT EXISTS idx_translations_state 
ON translations(state) 
WHERE state IN ('processing');

-- server/channels/db/migrations/postgres/000151_add_autotranslationdisabled_to_channelmembers.up.sql
-- Add new autotranslationdisabled column (opt-out semantics)
-- Default false means autotranslation is ENABLED by default
ALTER TABLE channelmembers
    ADD COLUMN IF NOT EXISTS autotranslationdisabled boolean NOT NULL DEFAULT false;

-- server/channels/db/migrations/postgres/000152_translations_primary_key_change.up.sql
-- Safety: Set objectType to 'post' for any NULL rows (table should be empty)
UPDATE translations SET objectType = 'post' WHERE objectType IS NULL;

-- Make objectType NOT NULL
ALTER TABLE translations ALTER COLUMN objectType SET NOT NULL;

-- Change primary key to include objectType
ALTER TABLE translations DROP CONSTRAINT translations_pkey;
ALTER TABLE translations ADD PRIMARY KEY (objectId, objectType, dstLang);

