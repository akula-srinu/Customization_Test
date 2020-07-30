-- Title
--    wnoetx_parentchild_Defaults.sql
-- Function
--    Sets the defaults for the Parent-Child Hierachies.
--
-- Description
--    Sets the defaults for the Parent-Child Hierachies.
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   22-Apr-13 D Glancy   Created.
--
-- ---------------------- DEFINE NOETIX COMMON REPOSITORY APPLICATION ----------------------
--
-- The following variables can be updated by the user if it is necessary for their particular 
-- environements.
--
-- The XXHIE_HIERARCHY_MAX_LEVELS defines the maximum number of levels needed for generating hierarchies.
-- This can be any number between 6 and 20.  If you specify a larger value than 20, it will set the value to 20.
-- If you set a value less than 6 then it will be set to 6 in the code.  The default is 11 levels.
define XXHIE_GL_HIERARCHY_MAX_LEVELS=11
-- The XXHIE_PARALLEL_DEGREE defines the maximum degree of parallelism for the hierarchy query.
-- This can be any number between 2 and 32.  If you specify a larger value than 32, it will set the value to 32.
-- If you set a value less than 2 then it will be set to 2 in the code.  The default is 8.
define XXHIE_PARALLEL_DEGREE=8

--
--------------------------------------------------------------------------------
--

-- end wnoetx_parentchild_defaults.sql
