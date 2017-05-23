# cookbook-cloud-backup

Does some stuff.

## Supported Platforms

Some platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['cookbook-letsencrypt']['configs']</tt></td>
    <td>Array</td>
    <td>Array of hashes detailing the certificates needed, whether it's for testing or production, and if to actually try and obtain those certificates. An example hash is: `{ :email => 'admin@mydomain.com', :domains => ['mydomain.com'] }`.</td>
    <td><tt>[]</tt></td>
  </tr>
</table>

## Usage

### cookbook-cloud-backup::default

Include `cookbook-cloud-backup` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[cookbook-cloud-backup::default]"
  ]
}
```

## License and Authors

Author:: Earth U (<iskitingbords @ gmail.com>)
