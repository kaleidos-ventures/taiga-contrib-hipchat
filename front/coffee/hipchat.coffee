@.taigaContribPlugins = @.taigaContribPlugins or []

hipChatInfo = {
    slug: "hipchat"
    name: "HipChat"
    type: "admin"
    module: 'taigaContrib.hipchat'
}

@.taigaContribPlugins.push(hipChatInfo)

module = angular.module('taigaContrib.hipchat', [])

debounce = (wait, func) ->
    return _.debounce(func, wait, {leading: true, trailing: false})

initHipChatPlugin = ($tgUrls) ->
    $tgUrls.update({
        "hipchat": "/hipchat"
    })

class HipChatAdmin
    @.$inject = [
        "$rootScope",
        "$scope",
        "$tgRepo",
        "tgAppMetaService",
        "$tgConfirm",
        "$tgHttp",
    ]

    constructor: (@rootScope, @scope, @repo, @appMetaService, @confirm, @http) ->
        @scope.sectionName = "HipChat" # i18n
        @scope.sectionSlug = "hipchat"

        @scope.$on "project:loaded", =>
            promise = @repo.queryMany("hipchat", {project: @scope.projectId})

            promise.then (hipchathooks) =>
                @scope.hipchathook = {
                    project: @scope.projectId,
                    notify_userstory_create: true,
                    notify_userstory_change: true,
                    notify_userstory_delete: true,
                    notify_task_create: true,
                    notify_task_change: true,
                    notify_task_delete: true,
                    notify_issue_create: true,
                    notify_issue_change: true,
                    notify_issue_delete: true,
                    notify_wikipage_create: true,
                    notify_wikipage_change: true,
                    notify_wikipage_delete: true
                }
                if hipchathooks.length > 0
                    @scope.hipchathook = hipchathooks[0]

                title = "#{@scope.sectionName} - Plugins - #{@scope.project.name}" # i18n
                description = @scope.project.description
                @appMetaService.setAll(title, description)

            promise.then null, =>
                @confirm.notify("error")

    testHook: () ->
        promise = @http.post(@repo.resolveUrlForModel(@scope.hipchathook) + '/test')
        promise.success (_data, _status) =>
            @confirm.notify("success")
        promise.error (data, status) =>
            @confirm.notify("error")

module.controller("ContribHipChatAdminController", HipChatAdmin)

HipChatWebhooksDirective = ($repo, $confirm, $loading) ->
    link = ($scope, $el, $attrs) ->
        form = $el.find("form").checksley({"onlyOneErrorElement": true})
        submit = debounce 2000, (event) =>
            event.preventDefault()

            return if not form.validate()

            currentLoading = $loading()
                .target(submitButton)
                .start()

            if not $scope.hipchathook.id
                promise = $repo.create("hipchat", $scope.hipchathook)
                promise.then (data) ->
                    $scope.hipchathook = data
            else if $scope.hipchathook.url
                promise = $repo.save($scope.hipchathook)
                promise.then (data) ->
                    $scope.hipchathook = data
            else
                promise = $repo.remove($scope.hipchathook)
                promise.then (data) ->
                    $scope.hipchathook = {
                        project: $scope.projectId,
                        notify_userstory_create: true,
                        notify_userstory_change: true,
                        notify_userstory_delete: true,
                        notify_task_create: true,
                        notify_task_change: true,
                        notify_task_delete: true,
                        notify_issue_create: true,
                        notify_issue_change: true,
                        notify_issue_delete: true,
                        notify_wikipage_create: true,
                        notify_wikipage_change: true,
                        notify_wikipage_delete: true
                    }

            promise.then (data)->
                currentLoading.finish()
                $confirm.notify("success")

            promise.then null, (data) ->
                currentLoading.finish()
                form.setErrors(data)
                if data._error_message
                    $confirm.notify("error", data._error_message)

        submitButton = $el.find(".submit-button")

        $el.on "submit", "form", submit
        $el.on "click", ".submit-button", submit

    return {link:link}

module.directive("contribHipchatWebhooks", ["$tgRepo", "$tgConfirm", "$tgLoading", HipChatWebhooksDirective])

module.run(["$tgUrls", initHipChatPlugin])
