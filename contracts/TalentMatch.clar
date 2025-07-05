(define-data-var job-count uint u0)

(define-map jobs
  { id: uint }
  {
    employer: principal,
    title: (string-ascii 100),
    description: (string-ascii 500),
    salary: uint,
    posted-at: uint
  }
)

(define-map applications
  { job-id: uint, applicant: principal }
  {
    applied-at: uint,
    status: (string-ascii 20)
  }
)

;; Events are not supported in Clarity, so these lines are removed.

;; Post a new job
(define-public (post-job (title (string-ascii 100)) (description (string-ascii 500)) (salary uint))
  (let ((job-id (var-get job-count)))
    (begin
      (map-set jobs {id: job-id}
        {
          employer: tx-sender,
          title: title,
          description: description,
          salary: salary,
          posted-at: u0
        }
      )
      (var-set job-count (+ job-id u1))
      ;; Removed invalid print statement for job-posted event
      (ok job-id)
    )
  )
)

;; Apply to an existing job
(define-public (apply (job-id uint))
  (begin
    (asserts! (is-some (map-get? jobs {id: job-id})) (err "Job does not exist"))
    (asserts! (is-none (map-get? applications {job-id: job-id, applicant: tx-sender})) (err "Already applied"))
    (map-set applications {job-id: job-id, applicant: tx-sender}
      {
        applied-at: u0,
        status: "pending"
      }
    )
    (ok true)
  )
)

;; Get total job count
(define-read-only (get-job-count)
  (ok (var-get job-count))
)

;; Check if a user applied to a job
(define-read-only (has-applied (job-id uint) (user principal))
  (ok (is-some (map-get? applications {job-id: job-id, applicant: user})))
)

;; Get job details
(define-read-only (get-job (job-id uint))
  (match (map-get? jobs {id: job-id})
    job-data (ok job-data)
    (err u102) ;; job not found
  )
)

;; Get application status for a user
(define-read-only (get-application-status (job-id uint) (user principal))
  (match (map-get? applications {job-id: job-id, applicant: user})
    app (ok app)
    (err u103)
  )
) 

;; Cancel application (by user)
(define-public (cancel-application (job-id uint))
  (match (map-get? applications {job-id: job-id, applicant: tx-sender})
    some-app
      (begin
        (map-delete applications {job-id: job-id, applicant: tx-sender})
        (ok "Application cancelled")
      )
    (err "Application not found")
  )
)
