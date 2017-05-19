<?php

namespace Drupal\opencrm_demo\Plugin\DemoContent;

use Drupal\opencrm_demo\DemoFile;

/**
 * @DemoContent(
 *   id = "file",
 *   label = @Translation("File"),
 *   source = "content/entity/file.yml",
 *   entity_type = "file"
 * )
 */
class File extends DemoFile {

}
