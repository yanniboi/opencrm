<?php
/**
 * @file
 * Enables modules and site configuration for an opencrm site installation.
 */

/**
 * Implements hook_install_tasks().
 */
function opencrm_install_tasks(&$install_state) {
  $tasks = array(
    'opencrm_install_profile_modules' => array(
      'display_name' => t('Install OpenCRM modules'),
      'type' => 'batch',
    ),
  );
  return $tasks;
}

/**
 * Installs required modules via a batch process.
 *
 * @param $install_state
 *   An array of information about the current installation state.
 *
 * @return array
 *   The batch definition.
 */
function opencrm_install_profile_modules(&$install_state) {
  $files = system_rebuild_module_data();

  $modules = array(
    'contacts' => 'contacts',
  );
  $opencrm_modules = $modules;
  // Always install required modules first. Respect the dependencies between
  // the modules.
  $required = array();
  $non_required = array();

  // Add modules that other modules depend on.
  foreach ($modules as $module) {
    if ($files[$module]->requires) {
      $module_requires = array_keys($files[$module]->requires);
      // Remove the opencrm modules from required modules.
      $module_requires = array_diff_key($module_requires, $opencrm_modules);
      $modules = array_merge($modules, $module_requires);
    }
  }
  $modules = array_unique($modules);
  // Remove the opencrm modules from to install modules.
  $modules = array_diff_key($modules, $opencrm_modules);
  foreach ($modules as $module) {
    if (!empty($files[$module]->info['required'])) {
      $required[$module] = $files[$module]->sort;
    }
    else {
      $non_required[$module] = $files[$module]->sort;
    }
  }
  arsort($required);

  $operations = array();
  foreach ($required + $non_required + $opencrm_modules as $module => $weight) {
    $operations[] = array('_opencrm_install_module_batch', array(array($module), $module));
  }

  $batch = array(
    'operations' => $operations,
    'title' => t('Install OpenCRM modules'),
    'error_message' => t('The installation has encountered an error.'),
  );
  return $batch;
}

/**
 * Implements callback_batch_operation().
 *
 * Performs batch installation of modules.
 */
function _opencrm_install_module_batch($module, $module_name, &$context) {
  set_time_limit(0);
  \Drupal::service('module_installer')->install($module, $dependencies = TRUE);
  $context['results'][] = $module;
  $context['message'] = t('Install %module_name module.', array('%module_name' => $module_name));
}
