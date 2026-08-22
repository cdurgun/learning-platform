document.addEventListener('DOMContentLoaded', function () {
    var section = document.getElementById('quiz-section');
    if (!section) {
        return;
    }

    var form = document.getElementById('quiz-form');
    var submitBtn = document.getElementById('quiz-submit-btn');
    var summary = document.getElementById('quiz-summary');
    var questionEls = section.querySelectorAll('.quiz-question');
    var totalQuestions = questionEls.length;
    var answered = new Map();

    var msgScore = section.dataset.msgScore || 'Score: {0}/{1}';
    var msgPassed = section.dataset.msgPassed || 'Passed!';
    var msgFailed = section.dataset.msgFailed || 'Not passed.';
    var msgError = section.dataset.msgError || 'Something went wrong. Please try again.';

    function updateSubmitState() {
        submitBtn.disabled = answered.size !== totalQuestions;
    }

    section.querySelectorAll('.quiz-option-input').forEach(function (input) {
        input.addEventListener('change', function () {
            answered.set(input.dataset.questionId, input.value);
            updateSubmitState();
        });
    });

    function lockForm() {
        section.querySelectorAll('.quiz-option-input').forEach(function (input) {
            input.disabled = true;
        });
        submitBtn.disabled = true;
    }

    function showSummary(alertClass, text) {
        summary.className = 'alert mt-3 ' + alertClass;
        summary.textContent = text;
        summary.style.display = 'block';
    }

    function renderResults(response) {
        response.results.forEach(function (result) {
            var questionEl = section.querySelector('.quiz-question[data-question-id="' + result.questionId + '"]');
            if (!questionEl) {
                return;
            }
            questionEl.querySelectorAll('.quiz-option-input').forEach(function (input) {
                var formCheck = input.closest('.form-check');
                if (Number(input.value) === result.selectedOptionId) {
                    formCheck.classList.add(result.correct ? 'text-success' : 'text-danger');
                }
                if (!result.correct && Number(input.value) === result.correctOptionId) {
                    formCheck.classList.add('text-success');
                }
            });
            var feedback = questionEl.querySelector('.quiz-result-feedback');
            feedback.textContent = result.explanation;
            feedback.style.display = 'block';
        });

        var scoreText = msgScore.replace('{0}', response.score).replace('{1}', response.total);
        var statusText = response.passed ? msgPassed : msgFailed;
        showSummary(response.passed ? 'alert-success' : 'alert-warning', scoreText + ' — ' + statusText);
    }

    form.addEventListener('submit', function (event) {
        event.preventDefault();
        var selectedOptionIds = Array.from(answered.values()).map(Number);

        fetch(section.dataset.submitUrl, {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({selectedOptionIds: selectedOptionIds})
        })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error('quiz submit failed: ' + response.status);
                }
                return response.json();
            })
            .then(function (data) {
                lockForm();
                renderResults(data);
            })
            .catch(function () {
                showSummary('alert-danger', msgError);
            });
    });
});
