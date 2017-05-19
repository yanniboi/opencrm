<?php

namespace Drupal\opencrm_demo\Plugin\DemoContent;

use Drupal\opencrm_demo\DemoUser;

/**
 * @DemoContent(
 *   id = "user",
 *   label = @Translation("User"),
 *   source = "content/entity/user.yml",
 *   entity_type = "user"
 * )
 */
class User extends DemoUser {

}
