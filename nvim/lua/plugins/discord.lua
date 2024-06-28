return {
  'andweeb/presence.nvim',
  enabled = false,
  config = function()
    require('presence').setup {
      enable_line_number = false,
      log_level = 'debug',
      presence_log_level = 'debug',

      editing_text = 'Editing file...',
      file_exporer_text = 'Browsing file system...',
      git_commit_text = 'Committing changes',
      plugin_manager_text = 'Managing plugins',
      reading_text = 'Reading file...',
      workspace_text = 'Working in a workspace...',
      line_number_text = 'Line %s out of %s',
    }
  end,
}
