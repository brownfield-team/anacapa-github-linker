module CoursesHelper

    def projectTeamName?(teamName)
        blockList = [
            'CS480-Spring2020',
            'CS Club',
        ].map{ |p| 
            !teamName.start_with?(p)
        }.reduce(:&)
    end

    def selectProjectTeam(teamNames)
        winners = teamNames.select{ |name| projectTeamName?(name)}
        winners.empty? ? "" : winners.first
    end

    def uid2TeamMap(course)
        result = {}
        course.roster_students.each do |rs|
            begin
                teamNames = rs.org_teams.map{ |t| t.name }
                result[rs.user.uid] = selectProjectTeam(teamNames)
            rescue
            end
        end
        result
    end

    def uid2StudentMap(course)
        result = {}
        course.roster_students.each do |rs|
          begin
            result[rs.user.uid] = {
                login: rs.user.username,
                name: rs.full_name,
                teams: rs.org_teams
            }
          rescue
          end
        end
        result
    end
end
