name             'cookbook-cloud-backup'
maintainer       'Earth U'
maintainer_email 'iskitingbords @ gmail . com'
license          'Apache License'
description      'Installs/Configures cookbook-cloud-backup'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/nollieheel/cookbook-cloud-backup'
issues_url       'https://github.com/nollieheel/cookbook-cloud-backup/issues'
version          '0.1.0'

depends 'awscli'
depends 'cron'
depends 'tar'

supports 'ubuntu', '14.04'
