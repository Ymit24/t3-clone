module RougeTheme
  def self.css
    Rouge::Themes::Github.mode(:dark).render(scope: '.highlight')
  end
end
