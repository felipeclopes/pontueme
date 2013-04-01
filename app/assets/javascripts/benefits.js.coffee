# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class Pontueme.Benefit
  @checkins_needed = ko.observable(null)
  @name = ko.observable("")
  @description = ko.observable("")


class Pontueme.BenefitsViewModel
  constructor: () ->
    self = this
    @benefits = ko.observableArray([])

    $.getJSON("/benefits.json", (allData) -> 
        mappedBenefits = $.map(allData, (item) -> 
          return ko.mapping.fromJS(item))
        self.benefits(mappedBenefits)
      )

    @newBenefit = ko.observable(new Pontueme.Benefit())

    @save = =>
      $.ajax("/benefits", {
            data: ko.toJSON({ benefit: @newBenefit }),
            type: "post", contentType: "application/json",
            success: (result) -> 
              self.benefits.push(result.benefit)
        });

    @removeBenefit = (benefit) =>
      $.ajax("/benefits/" + benefit.id(), {
            type: "delete", contentType: "application/json",
            success: (result) -> 
              self.benefits.remove(benefit)
        });

