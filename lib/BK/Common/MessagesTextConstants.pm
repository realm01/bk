#!/usr/bin/env perl

BEGIN {

    package MessagesTextConstants;

    use Exporter 'import';

    our @EXPORT = qw(
        DBERRCONNMSG
        DBERRDISCONNMSG
        DBERRCREATEMSG
        DBERRREADMSG
        DBERRUPDATEMSG
        DBERRDELETEMSG
        DBERRCOMMITMSG
        DBERRROLLBACKMSG
        AHSDIDEN
        AHSDDEL
        AHSDNEW
    );

    ##  --
    ##  db error excetions

    use constant {
        DBERRCONNMSG     => 'Failed to Connect to Database',
        DBERRDISCONNMSG  => 'Failed to Disconnect from Database',
        DBERRCREATEMSG   => 'Failed to Create Entry in Database',
        DBERRREADMSG     => 'Failed to Read from Database',
        DBERRUPDATEMSG   => 'Failed to Update Entry in Database',
        DBERRDELETEMSG   => 'Failed to Detele Entry in Database',
        DBERRCOMMITMSG   => 'Failed to Commit changes',
        DBERRROLLBACKMSG => 'Failed to Rollback changes'
    };

    ##  --
    ##  action handler messages

    use constant {
        AHSDIDEN => 'Data is the same no Changes are made',     ##  action handler save data is identically to the existing
        AHSDDEL  => 'Data is getting Deleted',                  ##  action handler save data is removed by user data is getting deleted in database
        AHSDNEW  => 'New Data is getting Inserted in Database'  ##  action handler save data is added a new value by user data is getting inserted in to database
    };

    ##  --
    ##  action handler exceptions

    use constant {
        AHUNKNOWNACTIONMSG => 'unknown request'
    };

}

1;