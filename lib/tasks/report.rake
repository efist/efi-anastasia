namespace :report do
  desc "TODO"
  task dot: :environment do
  `dot -Gdpi=150 -Tpng tmp/a.dot -o report/figures/db.png`
  end

end
