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

    var msgScore = section.dataset.msgScore || 'Score: {0}/{1}';
    var msgPassed = section.dataset.msgPassed || 'Passed!';
    var msgFailed = section.dataset.msgFailed || 'Not passed.';
    var msgError = section.dataset.msgError || 'Something went wrong. Please try again.';

    // Bir sorunun "cevaplanmış" sayılması için en az bir şıkkının işaretli
    // olması yeterli -- bu, hem bugünkü radio (SINGLE_CHOICE/CODE_OUTPUT)
    // input'larında hem de ileride checkbox olarak render edilebilecek
    // MULTIPLE_CHOICE sorularında değişiklik gerektirmeden çalışır.
    function answeredQuestionCount() {
        var ids = new Set();
        section.querySelectorAll('.quiz-option-input:checked').forEach(function (input) {
            ids.add(input.dataset.questionId);
        });
        return ids.size;
    }

    function updateSubmitState() {
        submitBtn.disabled = answeredQuestionCount() !== totalQuestions;
    }

    section.querySelectorAll('.quiz-option-input').forEach(function (input) {
        input.addEventListener('change', updateSubmitState);
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
            var selectedIds = (result.selectedOptionIds || []).map(String);
            var correctIds = (result.correctOptionIds || []).map(String);
            questionEl.querySelectorAll('.quiz-option-input').forEach(function (input) {
                var formCheck = input.closest('.form-check');
                var isSelected = selectedIds.indexOf(input.value) !== -1;
                var isCorrectOption = correctIds.indexOf(input.value) !== -1;
                if (isSelected) {
                    formCheck.classList.add(result.correct ? 'text-success' : 'text-danger');
                }
                if (!result.correct && isCorrectOption) {
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

    // Backend, Faz B'den itibaren gruplu bir answers[] listesi bekliyor
    // (QuizSubmitRequest/QuizAnswer) -- her soru için işaretli şık(lar)ı ayrı
    // ayrı topluyoruz, DOM sırasına dayalı düz bir selectedOptionIds listesi
    // ARTIK YOK (bkz. QuizAnswer javadoc'u).
    function collectAnswers() {
        var answers = [];
        questionEls.forEach(function (questionEl) {
            var questionId = Number(questionEl.dataset.questionId);
            var selectedOptionIds = Array.from(questionEl.querySelectorAll('.quiz-option-input:checked'))
                .map(function (input) {
                    return Number(input.value);
                });
            answers.push({questionId: questionId, selectedOptionIds: selectedOptionIds});
        });
        return answers;
    }

    form.addEventListener('submit', function (event) {
        event.preventDefault();

        fetch(section.dataset.submitUrl, {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({answers: collectAnswers()})
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
